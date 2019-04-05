classdef Mesh < handle
  % Holds mesh data
  properties (SetAccess=private)
    dim = 0;
    targetDim = 0;
    nodes;
    elements;
    regions;
    nodemap;
    cells2elements; % N x 2 array (columns: cells, elements)
    faces2elements; % N x 2 array (columns: faces, elements)
    edges2elements; % N x 2 array (columns: edges, elements)
    f2eOrient;
    parent;
    childrens;
    parentNodesMap;
    parentElemsMap;
    isDual = false;
  end
  properties (Access = private)
    adjacencies;
    simplical = -1;
    dim2CellTypes;
    geomTransArray; % Cell array of geometric transformations
  end
  properties (Constant)
    readFormats = {'msh'};
    writeFormats = {'msh'};
  end
  methods
    function [obj] = Mesh(dim, nodes, elements, regions, nodemap)
      % Consctruct new mesh
      obj.dim = dim;
      obj.targetDim = 3;
      obj.nodes = nodes;
      obj.elements = elements;
      obj.regions = regions;
      obj.nodemap = nodemap;
      obj.adjacencies = cell(4,4);
      obj.cells2elements = uint32.empty;
      obj.faces2elements = uint32.empty;
      obj.edges2elements = uint32.empty;
      obj.f2eOrient = {};
      obj.dim2CellTypes  = cell(1, obj.dim);
      obj.parent = [];
      obj.childrens = [];
      obj.parentNodesMap = [];
      obj.parentElemsMap = [];
      obj.isDual = false;
      obj.setupGeomTrans();
    end
    function setTargetDim(obj, targetDim)
      if targetDim < obj.dim
        error('Target dimension cannot be smaller than intrinsic dimension');
      end
      if targetDim > 3
        error('Target dimension cannot be greater than 3');
      end
      obj.targetDim = targetDim;
    end
    function [gt] = geomTrans(obj, dimension)
      if nargin < 2
        dimension = obj.dim;
      end
      gt = obj.geomTransArray{dimension};
    end
    function [gt] = elemGeomTrans(obj, elemId)
      % Maybe it would be faster to store geom trans indeks for each
      % element than to map it through element type and dimension.
      ed = mp_gmsh_elem_dim(obj.elems{elemId});
      gt = obj.geomTransArray{ed};
    end
    function setParent(obj, parent_, nodesMap, elemsMap)
      obj.parent = parent_;
      parent_.childrens = [parent_.childrens , obj];
      obj.parentNodesMap = nodesMap;
      obj.parentElemsMap = elemsMap;
    end
    function printRegions(obj, fid)
      if nargin < 2
        fid = 1;
      end
      mp_gmsh_regions_printf(obj.regions, fid);
    end
    function m = getDual(obj)
      t = obj.singleElemType();
      if t ~= 2
        error('Dual meshed can be constructed only from triangular meshes');
      end
      f2v = obj.getAdjacency(2,0);
      tt = cell2mat(f2v.targets');
      [CP,CE,dualNodes,EV] = makedual2(obj.nodes.Data, tt);
      ncp = length(CP);
      coords = mp.SharedArray(1);
      coords.Data = dualNodes;
      dualElements = mp.SharedCellArray(ncp);
      for i = 1:ncp
        de = EV(CE(CP(i,2):CP(i,3)),:);
        n = size(de, 1);
        if n > 4
          etype = 500+n;
        else
          etype = n-1;
        end
        verts = mp_recover_face_from_edges(de);
        cv = [verts, verts(1)];
        x = dualNodes(cv(2:end), 1)-dualNodes(cv(1:end-1), 1);
        y = dualNodes(cv(2:end), 2)+dualNodes(cv(1:end-1), 2);
        s = sum(x.*y);
        if s < 0
            verts = fliplr(verts);
        end
        dualElements{i} = [i,etype,2,1,0,verts];
      end
      m = mp.Mesh(obj.dim, coords, dualElements, [], []);
      m.isDual = true;
      m.setParent(obj, [], []);
    end
    function t=singleElemType(obj, varargin)
      % singleElemType - check if mesh is of single element type
      % Normally check only element of dimension equal to mesh dimension.
      % If called as mesh.singleElemType('all') then consders all element
      % types.
      checkAll = false;
      if ~isempty(varargin) && strcmp(varargin{1}, 'all')
        checkAll = true;
      end
      t = -1;
      for i = 1:obj.elemsCount()
        elem = obj.elements{i};
        if ~checkAll
          if obj.dim ~= mp_gmsh_element_dim(elem)
              continue
          end
        end
        if t < 0
            t = elem(2);
        end
        tc = elem(2);
        if tc ~= t
            t = 0;
            break
        end
      end
    end
    function [type] = elementGmshType(obj, elemId)
      % Return gmsh type of given element
      type = obj.elements{elemId}(2);
    end
    function [ct] = cellTypes(obj, dimension)
      % Return vector of cell types for mesh elements. If and argument is
      % given it is the dimension to which the search should be restricted
      % Example:
      %   mesh.cellTypes() return the cell type of dimension equal to
      %   dimension of the mesh
      %
      %   mesh.cellTypes(1) return the cell type of 1D elements
      if nargin < 2 || isempty(dimension)
        dimension = obj.dim;
      end
      if ~isempty(obj.dim2CellTypes{dimension})
         ct = obj.dim2CellTypes{dimension};
         return;
      end
      cells = mp_gmsh_elems_find(obj.elements, struct('dim', dimension));
      info = struct();
      for i=cells
        typetag = mp_gmsh_element_typetag(obj.elements{i});
        if isfield(info, typetag)
          info.(typetag) = info.(typetag)+1;
        else
          info.(typetag) = 1;
        end
      end
      fn = fieldnames(info);
      ct = [];
      for name=fn'
        info = mp_gmsh_types_info(name{:});
        ct = [ct, info.type];
      end
      obj.dim2CellTypes{dimension} = ct;
    end
    function [val] = faceEdgeOrient(obj, face, edgeNum)
      obj.updateAdjacency(2, 1);
      v = obj.f2eOrient{face};
      val = v(edgeNum);
    end

    function [adj] = getAdjacency(obj, from, to)
      % Return Adjacency object. Arguments 'from' and 'to' are dimensions of
      % topological mesh entities for which adjacency should be calculated.
      f = mp.Topo(from)+1;
      t = mp.Topo(to)+1;
      if isempty(obj.adjacencies{f,t})
        obj.updateAdjacency(from, to);
      end
      adj = obj.adjacencies{f,t};
    end
    function [elemsIds] = elemsFromIds(obj, ids)
      % Return GMSH element indices from given set if indices assuming it
      % pertains to elements of the highest dimension present in the mesh,
      % that is elements of dimension equal to mesh dimension.
      checker = {@obj.elemsFromEdges,
                 @obj.elemsFromFaces,
                 @obj.elemsFromCells};
      h = checker{obj.dim};
      elemsIds = h(ids);
    end
    function [elemsIds] = elemsFromCells(obj, cellIds)
      % Return Id of elements corresponding to given cell
      cellIds = uint32(cellIds);
      obj.updateCells2Elems();
      [iv, indices] = ismember(cellIds, obj.cells2elements(:,1));
      if(~iv)
        invalid = cellIds(find(iv==0));
        s = sprintf(' %d', invalid);
        error('Cells below do not correspond to an element:\n%s',s);
      end
      elemsIds = obj.cells2elements(indices,2)';
    end
    function [elemsIds] = elemsFromFaces(obj, faceIds)
      % Return Id of elements corresponding to given faces
      faceIds = uint32(faceIds);
      obj.updateFaces2Elems();
      [iv, indices] = ismember(faceIds, obj.faces2elements(:,1));
      if(~iv)
        invalid = facesIds(find(iv==0));
        s = sprintf(' %d', invalid);
        error('Faces below do not correspond to an element:\n%s',s);
      end
      elemsIds = obj.faces2elements(indices,2)';
    end
    function [elemsIds] = elemsFromEdges(obj, edgeIds)
      % Return Id of elements corresponding to given edge
      edgeIds = uint32(edgeIds);
      obj.updateEdges2Elems();
      [iv, indices] = ismember(edgeIds, obj.edges2elements(:,1));
      if(~iv)
        invalid = edgeIds(iv==0);
        s = sprintf(' %d', invalid);
        error('Edges below do not correspond to an element:\n%s',s);
      end
      elemsIds = obj.edges2elements(indices,2)';
    end
    function [edgesIds] = edgesFromElems(obj, elemIds)
      obj.updateEdges2Elems();
      elemIds = uint32(elemIds);
      [iv, indices] = ismember(elemIds, obj.edges2elements(:,2));
      if(~iv)
        invalid = elemIds(find(iv==0));
        s = sprintf(' %d', invalid);
        error('Elements below do not correspond to an edge:\n%s',s);
      end
      edgesIds = obj.edges2elements(indices,1)';
    end
    function updateEdges2Elems(obj)
      % Make sure the data member edges2elements is properly initialized
      if isempty(obj.edges2elements)
        elems1D = mp_gmsh_elems_find(obj.elements, struct('dim', 1));
        nelem = length(elems1D);
        obj.edges2elements = zeros(nelem, 2, 'uint32');
        for i=1:nelem
          nnodes = mp_gmsh_node_count(obj.elements{elems1D(i)}(2));
          nodesID = obj.elements{elems1D(i)}(end-nnodes+1:end);
          edgeID = obj.findEdgeSpannedByNodes(nodesID);
          obj.edges2elements(i,1) = edgeID;
          obj.edges2elements(i,2) = elems1D(i);
        end
      end
    end
    function updateFaces2Elems(obj)
      % Make sure the data member faces2elements is properly initialized
      if isempty(obj.faces2elements)
        elems2D = mp_gmsh_elems_find(obj.elements, struct('dim', 2));
        nelem = length(elems2D);
        obj.faces2elements = zeros(nelem, 2, 'uint32');
        for i=1:nelem
          nnodes = mp_gmsh_node_count(obj.elements{elems2D(i)}(2));
          nodesID = obj.elements{elems2D(i)}(end-nnodes+1:end);
          faceID = obj.findFaceSpannedByNodes(nodesID);
          obj.faces2elements(i,1) = faceID;
          obj.faces2elements(i,2) = elems2D(i);
        end
      end
    end
    function updateCells2Elems(obj)
      % Make sure the data member cells2elements is properly initialized
      if isempty(obj.cells2elements)
        elems3D = mp_gmsh_elems_find(obj.elements, struct('dim', 3));
        nelem = length(elems3D);
        obj.cells2elements = zeros(nelem, 2, 'uint32');
        for i=1:nelem
          nnodes = mp_gmsh_node_count(obj.elements{elems3D(i)}(2));
          nodesID = obj.elements{elems3D(i)}(end-nnodes+1:end);
          cellID = obj.findCellSpannedByNodes(nodesID);
          obj.cells2elements(i,1) = cellID;
          obj.cells2elements(i,2) = elems3D(i);
        end
      end
    end
    function updateAdjacency(obj, from, to)
      f = mp.Topo(from)+1;
      t = mp.Topo(to)+1;
      if isempty(obj.adjacencies{f,t})
        updaters = obj.getAdjacencyUpdaters();
        func = updaters{f, t};
        func();
      end
    end
    function [cellId] = findCellSpannedByNodes(obj, nodesID)
      cellId = obj.findEntitySpannedByNodes(nodesID, mp.Topo.Cell);
    end
    function [faceId] = findFaceSpannedByNodes(obj, nodesID)
      % Return Id of face spanned by nodes or 0 if no such face exists.
      faceId = obj.findEntitySpannedByNodes(nodesID, mp.Topo.Face);
    end
    function [edgeId] = findEdgeSpannedByNodes(obj, nodesID)
      % Return Id of edge spanned by nodes or 0 if no such edege exists.
      edgeId = obj.findEntitySpannedByNodes(nodesID, mp.Topo.Edge);
    end
    function [regionID] = getElemRegion(obj, elemsID)
      % Return ID of region to which elements of given IDs belong.
      regionID = cellfun(@(c) c(4), obj.elements(elemsID), 'UniformOutput', true);
    end
    function [regionID] = getFaceRegion(obj, facesID)
      % Return ID of region to which faces of give IDs belong.
      elemsID = obj.elemsFromFaces(facesID);
      regionID = obj.getElemRegion(elemsID);
    end
    function [regionName] = getRegionName(obj, regionID)
      idx = mp_gmsh_regions_find(obj.regions, struct('id', regionID));
      regionName = obj.regions(idx).name;
    end
    function [regionsIds] = findRegions(obj, selector)
      % Retrun ID of regions matching given selection criteria.
      %
      % Arguments:
      %   * selector - structure with values of search fields.
      %     Supported selector fields are:
      %
      %     - dim - topological dimension
      %     - name - exact match for region name
      %     - regexp - regular expression to match region name
      %     - id - region id
      %
      regionsIds = mp_gmsh_regions_find_id(obj.regions, selector);
    end
    function [elemsIds] = findElems(obj, selector)
      % Return ID of elements matching give selection cirteria
      %
      % Arguments:
      %   * selector - structure with values of search fileds.
      %     Supported selector fields are:
      %
      %     - dim - element topological dimension
      %     - geom - ID of geometric entity the elment is contained in
      %     - region - ID of region element belongs to
      %     - type - integer corresponging to element type
      %
      % If more than one selector field is specified then element must match
      % all field values to be selected.
      elemsIds = mp_gmsh_elems_find(obj.elements, selector);
    end
    function [nodesIds] = elemNodes(obj, elemsId)
      % Return Id of nodes of given element.
      % If single element is specified the returned vector corresponds
      % to element connectivity.
      % If more elements are specified then the returned vector is a sorted
      % union of unique nodes Id.
      nodesIds = mp_gmsh_element_nodes(obj.elements{elemsId(1)});
      if length(elemsId) > 1
        for i=elemsId
          nodesIds = [nodesIds, mp_gmsh_element_nodes(obj.elements{i})];
        end
        nodesIds = unique(nodesIds);
      end
    end
    function [nitems] = perDimCount(obj, dim)
      prefix = ['nodes'; 'edges'; 'faces'; 'cells'];
      nitems = obj.([prefix(dim+1,:),'Count'])();
    end
    function [nnodes] = nodesCount(obj)
      %% Return number of nodes in the mesh.
      nnodes = size(obj.nodes, 1);
    end
    function [nfaces] = facesCount(obj)
      %% Return number of faces in the mesh
      adj = obj.getAdjacency(2,0);
      nfaces = adj.length;
    end
    function [nedges] = edgesCount(obj)
      %% Return number of edges in the mesh
      adj = obj.getAdjacency(1,0);
      nedges = adj.length;
    end
    function [ncells] = cellsCount(obj)
      %% Return number of cells in the mesh
      adj = obj.getAdjacency(3, 0);
      ncells = adj.length;
    end
    function [nRegions] = regionsCount(obj, varargin)
      %% Return number of regions.
      % If no argument given then counts regions of the dimension equal
      % to the dimension of the mesh. Othervise counts regions of given
      % dimension.
      %
      % Example:
      %   mesh.regionsCount();
      %   mesh.regionsCount(2);
      if varargin < 1
        regdim = obj.dim;
      else
        regdim = varargin{1};
      end
      nRegions = mp_gmsh_regions_count(obj.regions, struct('dim', regdim));
    end

    function [names]  = regionNames(obj)
      %% Return cell array of region names
      names = arrayfun(@(K) K.name, obj.regions, 'UniformOutput', false);
    end

    function [nElems] = elemsCount(obj, varargin)
    %% Return number of elements.
    % If no argument given then return total number of elements in the
    % mesh. Otherwise return number of elements mathing give selection
    % cirteria
    % Example:
    % mesh.elemsCount();
    % mesh.elemsCount(struct('dim', 2));
      if isempty(varargin)
        nElems = length(obj.elements);
      else
        elemIds = mp_gmsh_elems_find(obj.elements, varargin{1});
        nElems = length(elemIds);
      end
    end
    function [centerCoords] = elemsCenters(obj, elemsID)
      %% Return shared array of face coordinates.
      if nargin < 2
        nelems = obj.elemsCount();
        elemsID = 1:nelems;
      else
        nelems = length(elemsID);
      end
      centerCoords = mp.SharedArray([nelems, 3]);
      i=1;
      for eid=elemsID
        elemNodes = mp_gmsh_element_nodes(obj.elements{eid});
        nodeCoords = obj.nodes(elemNodes, :);
        centerCoords(i, :) = sum(nodeCoords, 1)/length(elemNodes);
        i = i +1;
      end
    end
    function [dist] = nodesDistance(obj, nodesId)
        coords = obj.nodes(nodesId, :);
        dist = norm(coords(1,:)-coords(2,:));
    end
    function [centerCoords] = faceCenters(obj, faces)
      %% Return shared array of face coordinates.
      if nargin < 2
        nfaces = obj.facesCount();
        faces = 1:nfaces;
      else
        nfaces = length(faces);
      end
      centerCoords = zeros(nfaces, 3);
      adj = obj.getAdjacency(2, 0);
      i=1;
      for f = faces
        faceNodes = adj.at(f);
        nodeCoords = obj.nodes(faceNodes, :);
        centerCoords(i, :) = sum(nodeCoords, 1)/length(faceNodes);
        i = i+1;
      end
    end

    function [centerCoords] = edgeCenters(obj, edges)
      %% Return shared array of edge coordinates.
      % Caution: Current implementation works only for straight edges;
      if nargin < 2
        nedges = obj.edgesCount();
        edges = 1:nedges;
      else
        nedges = length(edges);
      end
      centerCoords = zeros(nedges, 3);
      adj = obj.getAdjacency(1, 0);
      i=1;
      for e=edges
        edgeNodes = adj.at(e);
        nodeCoords = obj.nodes(edgeNodes, :);
        centerCoords(i, :) = sum(nodeCoords, 1)/length(edgeNodes);
        i=i+1;
      end
    end
    function [localIndex] = getEdgeInFaceIndex(obj, edgeID, faceID)
      % For edge with global edgeID return its local index in givne face
      % or 0 if the edge does not belongs to the face.
      f2e = obj.getAdjacency(mp.Topo.Face, mp.Topo.Edge);
      edges = f2e.at(faceID);
      localIndex = find(edges == edgeID);
      if isempty(localIndex)
        localIndex = 0;
      end
    end
    function [normal, tangent] = csAtEdgeInFace(obj, edgeID, faceID)
      localIndex = obj.getEdgeInFaceIndex(edgeID, faceID);
      if localIndex == 0
        error('Edge %d not in face %d', edgeID, faceID);
      end
      e2v = obj.getAdjacency(mp.Topo.Edge, mp.Topo.Vertex);
      edgenodes = e2v.at(edgeID);
      tv = obj.nodes(edgenodes(2),:) - obj.nodes(edgenodes(1),:);
      tangent = tv/norm(tv);
      if obj.faceEdgeOrient(faceID, localIndex) < 0
        tangent = -tangent;
      end
      normal = [tangent(2), -tangent(1), 0];
    end
    function [normal, tangent] = csAtLocalEdge(obj, faceID, localIndex)
      f2e = obj.getAdjacency(mp.Topo.Face, mp.Topo.Edge);
      edges = f2e.at(faceID);
      edgeID = edges(localIndex);
      e2v = obj.getAdjacency(mp.Topo.Edge, mp.Topo.Vertex);
      edgenodes = e2v.at(edgeID);
      tv = mesh.nodes(edgenodes(2),:) - mesh.nodes(edgenodes(1),:);
      tangent = tv/norm(tv);
      if mesh.faceEdgeOrient(faceID, localIndex) < 0
        tangent = -tangent;
      end
      normal = [tangent(2), -tangent(1)];
    end
    function write(obj, filePath)
      %% Writes mesh in GMSH format to specified file
      fid = fopen(filePath, 'w');
      fprintf(fid,'$MeshFormat\n');
      fprintf(fid,'2.2 0 8\n');
      fprintf(fid, 'EndMeshFormat\n');
      nregions = length(obj.regions);
      if nregions > 0
        fprintf(fid, '$PhysicalNames\n');
        fprintf(fid, '%d\n', nregions);
        for reg = obj.regions
          fprintf(fid, '%d %d "%s"\n', reg.id, reg.dim, reg.name);
        end
      end
      fprintf(fid, '$EndPhysicalNames\n');
      fprintf(fid, '$Nodes\n');
      fprintf(fid, '%d\n', obj.nodesCount());
      for i=1:obj.nodesCount()
        fprintf(fid, '%d %f %f %f\n', i, obj.nodes(i,:));
      end
      fprintf(fid, '$EndNodes\n');
      fprintf(fid, '$Elements\n');
      nelems = length(obj.elements);
      fprintf(fid, '%d\n', nelems);
      for i=1:nelems
        e = obj.elements{i};
        fprintf(fid, '%d ', e(1:end-1));
        fprintf(fid, '%d\n', e(end));
      end
      fprintf(fid, '$EndElements\n');
      fclose(fid);
    end
    function [submesh] = submeshFromRegions(obj, regionNames)
      %% Create mesh from specified regions.
      regionIds = mp_gmsh_regions_find_id(obj.regions, struct('name', {regionNames}));
      elemsIds = mp_gmsh_elems_find(obj.elements, struct('region', regionIds));
      nodesIds = mp_gmsh_nodes_from_elems(obj.elements, elemsIds);
      nnodes = length(nodesIds);
      newnodes = mp.SharedArray(1);
      newnodes.Data = obj.nodes.Data(nodesIds, :);
      orig2newNode = sparse(nodesIds, 1, 1:nnodes);
      nelems = length(elemsIds);
      newelements = mp.SharedCellArray(nelems);
      newdim = 0;
      for i=1:length(elemsIds)
        elemrec = obj.elements{elemsIds(i)};
        newdim = max(newdim, mp_gmsh_element_dim(elemrec));
        nen = mp_gmsh_node_count(elemrec(2));
        elemrec(end-nen+1:end) = orig2newNode(elemrec(end-nen+1:end),1);
        elemrec(4:5) = [0,0];
        newelements{i} = elemrec;
      end
      submesh = mp.Mesh(newdim, newnodes, newelements, struct(),[]);
      submesh.setParent(obj, nodesIds, elemsIds);
    end
  end
  %%-----------------------------------------------------------------------------
  % Private
  %------------------------------------------------------------------------------
  methods(Access=private)
    function setupGeomTrans(obj)
      obj.geomTransArray = cell(1,obj.dim);
      for dimension=1:obj.dim
        obj.geomTransArray{dimension} = mp.GeomTrans(obj, dimension);
      end
    end
    function [entityId] = findEntitySpannedByNodes(obj, nodesId, entityTopoDim)
      % Return ID of a mesh entity of given topological dimension spanned
      % by given set of nodes. If such entity does not exists return 0.
      n2ent = obj.getAdjacency(mp.Topo.Vertex, entityTopoDim);
      entitiesToCheck = n2ent.at(nodesId(1));
      for i=2:length(nodesId)
        entityMask = n2ent.at(nodesId(i));
        entitiesToCheck = intersect(entitiesToCheck, entityMask);
        if isempty(entitiesToCheck)
          entityId = 0;
          return;
        end
      end
      if length(entitiesToCheck) ~= 1
          error('Corrupted adjacencies: #%s entities of dim %d %s spanned by nodes %s\n', ...
                 mp_to_string(entitiesToCheck), entityTopoDim, mp_to_string(nodesID));
      end
      entityId = entitiesToCheck(1);
    end
    function checkSimplical(obj)
      if obj.simplical == -1
        type = obj.singleElemType();
        obj.simplical = (type == 2);
      end
    end
    function Vertex2Vertex(obj)
      n = length(obj.nodes);
      targets=mat2cell((1:n)', ones(n,1, 'uint32'))';
      obj.adjacencies{1,1} = mp.Adjacency(targets);
    end
    function Vertex2Edge(obj)
      d = obj.dim;
      if d > 2
        error('Not implemented for mesh dim > 2')
      end
      adj = obj.getAdjacency(mp.Topo.Edge, mp.Topo.Vertex);
      obj.adjacencies{1,2} = adj.inverse();
    end
    function Vertex2Face(obj)
      d = obj.dim;
      if d < 2
        error('Vertex2Face Called for 1D mesh')
      end
      V = mp.Topo(0);
      C = mp.Topo(d);
      if isempty(obj.adjacencies{C+1,V+1})
        obj.updateAdjacency(C,V);
      end
      obj.adjacencies{V+1, C+1} = obj.adjacencies{C+1, V+1}.inverse();
    end
    function Vertex2Cell(obj)
      d = obj.dim;
      if d < 3
        error('Vertex2Cell not called for 3D mesh')
      end
      V = mp.Topo(0);
      C = mp.Topo(d);
      if isempty(obj.adjacencies{C+1,V+1})
        obj.updateAdjacency(C,V);
      end
      obj.adjacencies{V+1, C+1} = obj.adjacencies{C+1, V+1}.inverse();
    end
    function Edge2Vertex_1D(obj)
      if obj.dim ~= 1
        error('Edge2Vertex_1D calle for mesh of dimension %d', obj.dim')
      end
      elems1D = mp_gmsh_elems_find(obj.elements, struct('dim', 1));
      nelem = length(elems1D);
      adj = cell(1, nelem);
      for i=1:nelem
        nnodes = mp_gmsh_node_count(obj.elements{elems1D(i)}(2));
        adj{i} = obj.elements{elems1D(i)}(end-nnodes+1:end);
      end
      obj.adjacencies{2,1} = mp.Adjacency(adj);
    end
    function Edge2Vertex_2D(obj)
      d = obj.dim;
      if d > 2
        error('Not implemented')
      end
      adj = obj.getAdjacency(mp.Topo.F, mp.Topo.V);
      D=uint32.empty;
      for i = adj.getSources()
        elemId = obj.elemsFromFaces(i);
        elemEdges = mp_gmsh_element_edges(obj.elements{elemId});
        for e=elemEdges
          D = [D; e{:}];
        end
      end
      D = sort(D, 2);
      D = unique(D, 'rows');
      targets = mat2cell(D, ones(size(D,1),1, 'uint32'))';
      obj.adjacencies{2,1} = mp.Adjacency(targets);
    end
    function Edge2Edge(obj)
      d = obj.dim;
      if d > 2
        error('Not implemented for dimension > 2')
      end
      e2v = obj.getAdjacency(1, 0);
      v2e = obj.getAdjacency(0, 1);
      nedges = e2v.length;
      targets = cell(1, nedges);
      for i = e2v.getSources()
        adjedges = uint32.empty;
        for v = e2v.at(i)
          for adje = v2e.at(v)
            if adje ~= i
              adjedges = [adjedges, adje];
            end
          end
        end
        targets{i} = adjedges;
      end
      obj.adjacencies{2,2} = mp.Adjacency(targets);
    end
    function Edge2Face(obj)
      if obj.dim > 2
        error('Not implemented for mesh dim > 2')
      end
      if obj.dim < 2
        error('Edge2Face Called for 1D mesh')
      end
      adj = obj.getAdjacency(2,1);
      obj.adjacencies{2,3} = adj.inverse();
    end
    function Edge2Cell(obj)
      error('Not implemented')
    end
    function Face2Vertex(obj)
      if obj.dim < 2
        error('Vertex2Face Called for 1D mesh')
      end
      if obj.dim == 2
        elems2D = mp_gmsh_elems_find(obj.elements, struct('dim', 2));
        nelem = length(elems2D);
        adj = cell(1, nelem);
        for i=1:nelem
          nnodes = mp_gmsh_node_count(obj.elements{elems2D(i)}(2));
          adj{i} = obj.elements{elems2D(i)}(end-nnodes+1:end);
        end
        obj.adjacencies{3,1} = mp.Adjacency(adj);
      end
    end
    function Face2Edge(obj)
      d = obj.dim;
      if d < 2
        error('Face2Edge Called for 1D mesh')
      end
      if d > 2
        error('Not implemented for dimension 3')
      end
      e2v = obj.getAdjacency(1,0);
      v2e = obj.getAdjacency(0,1);
      f2v = obj.getAdjacency(2,0);
      nfaces = obj.facesCount();
      targets = cell(1, nfaces);
      obj.f2eOrient = cell(1, nfaces);
      for i=1:nfaces
        elemID = obj.elemsFromFaces(i);
        et = mp_gmsh_element_type(obj.elements{elemID});
        elemInfo = mp_gmsh_types_info(et);
        edgesDef = elemInfo.edges;
        nedges = length(edgesDef);
        cellVerts = f2v.at(i);
        edgesInFace = zeros(1, nedges, 'uint32');
        edgesOrientInFace = -1*ones(1, nedges, 'int8');
        for ei = 1:nedges
          edge = edgesDef{ei};
          edgeVerts = cellVerts(edge);
          fe = v2e.at(edgeVerts(1));
          for j=2:length(edgeVerts)
            fej = v2e.at(edgeVerts(j));
            fe = intersect(fej, fe);
          end
          if length(fe) ~= 1
            error('Invalid empty edge of face %d local edge %d', i, ei);
          end
          edgesInFace(ei) = fe;
          edgeNodes = e2v.at(fe);
          if edgeNodes(1) == edgeVerts(1)
            edgesOrientInFace(ei) = 1;
          end
        end
        targets{i} = edgesInFace;
        obj.f2eOrient{i} = edgesOrientInFace;
      end
      obj.adjacencies{3,2} = mp.Adjacency(targets);
      %adj = obj.getAdjacency(1,2);
      %obj.adjacencies{3,2} = adj.inverse();
    end
    function Face2Face(obj)
      if obj.dim < 2
        error('Vertex2Face Called for 1D mesh')
      end
      if obj.dim > 2
        error('Not implemented')
      end
      f2e = obj.getAdjacency(2,1);
      e2f = obj.getAdjacency(1,2);
      nelems = f2e.length;
      targets = cell(1, nelems);
      for i=1:nelems
        af = [];
        for e = f2e.at(i)
          for ef = e2f.at(e)
            if ef ~= i
              af = [af, ef];
            end
          end
        end
        targets{i} = af;
      end
      obj.adjacencies{3,3} = mp.Adjacency(targets);
    end
    function Face2Cell(obj)
      error('Not implemented')
    end
    function Cell2Vertex(obj)
      if obj.dim ~= 3
        error('Cell2Vertex calld for mesh of dimension %d', obj.dim')
      end
      elems3D = mp_gmsh_elems_find(obj.elements, struct('dim', 3));
      nelem = length(elems3D);
      adj = cell(1, nelem);
      for i=1:nelem
        nnodes = mp_gmsh_node_count(obj.elements{elems3D(i)}(2));
        adj{i} = obj.elements{elems3D(i)}(end-nnodes+1:end);
      end
      obj.adjacencies{4,1} = mp.Adjacency(adj);
    end
    function Cell2Edge(obj)
      error('Not implemented')
    end
    function Cell2Face(obj)
      error('Not implemented')
    end
    function Cell2Cell(obj)
      error('Not implemented')
    end
    function [updaters] = getAdjacencyUpdaters(obj)
      updaters = cell(4,4);
      updaters{1,1} = @obj.Vertex2Vertex;
      updaters{1,2} = @obj.Vertex2Edge;
      updaters{1,3} = @obj.Vertex2Face;
      updaters{1,4} = @obj.Vertex2Cell;
      if obj.dim == 1
        updaters{2,1} = @obj.Edge2Vertex_1D;
      else
        updaters{2,1} = @obj.Edge2Vertex_2D;
      end
      updaters{2,2} = @obj.Edge2Edge;
      updaters{2,3} = @obj.Edge2Face;
      updaters{2,4} = @obj.Edge2Cell;
      updaters{3,1} = @obj.Face2Vertex;
      updaters{3,2} = @obj.Face2Edge;
      updaters{3,3} = @obj.Face2Face;
      updaters{3,4} = @obj.Face2Cell;
      updaters{4,1} = @obj.Cell2Vertex;
      updaters{4,2} = @obj.Cell2Edge;
      updaters{4,3} = @obj.Cell2Face;
      updaters{4,4} = @obj.Cell2Cell;
    end
  end
end
