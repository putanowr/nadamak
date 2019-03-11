classdef Mesh < handle
  % Holds mesh data 
  properties (SetAccess=private)
    dim = 0;
    nodes;
    elements;
    regions;
    nodemap;
    faces2elements;
  end
  properties (Access = private)
    adjacencies
  end
  methods
    function [obj] = Mesh(dim, nodes, elements, regions, nodemap)
      obj.dim = dim;
      obj.nodes = nodes;
      obj.elements = elements;
      obj.regions = regions;
      obj.nodemap = nodemap;
      obj.adjacencies = cell(4,4);
      obj.faces2elements = [];
    end
    function [adj] = getAdjacency(obj, from, to)
      f = mp.Topo(from)+1;
      t = mp.Topo(to)+1;
      if isempty(obj.adjacencies{f,t})
        obj.updateAdjacency(from, to);
      end
      adj = obj.adjacencies{f,t};
    end
    function updateAdjacency(obj, from, to)
      f = mp.Topo(from)+1;
      t = mp.Topo(to)+1;
      if isempty(obj.adjacencies{f,t})
        if ~isempty(obj.adjacencies{t,f})
          obj.adjacencies{f,t} = obj.adjacencies{t,f}.inverse();
        else
          updaters = obj.getAdjacencyUpdaters();
          func = updaters{f, t};
          func();
        end
      end
    end
    function [elemsIds] = findElems(obj, selector)
      %% Return ID of elements matching give selection cirteria
      % Arguments:
      % * selector - structure with values of search fileds. Supported selector
      %   fields are:
      %     dim - element topological dimension
      %     geom - ID of geometric entity the elment is contained in
      %     region - ID of region element belongs to
      %     type - integer corresponging to element type
      % If more than one selector field is specified then element must match
      % all field values to be selected.
      elemsIds = mp_gmsh_elems_find(obj.elements, selector);
    end
    function [nodesIds] = elemNodes(obj, elemId)
      %% Return ID of nodes of given element.
      nodesIds = mp_gmsh_element_nodes(obj.elements{elemId});
    end
    function [nnodes] = nodesCount(obj)
      %% Return number of nodes in the mesh.
      nnodes = size(obj.nodes, 1);
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
    function [nElems] = elemsCount(obj, varargin)
      %% Return number of regions. 
      % If no argument given then return total number of elements in the
      % mesh. Otherwise return number of elements mathing give selection
      % cirteria
      % Example:
      %   mesh.elemsCount();
      %   mesh.elemsCount(struct('dim', 2));
      if isempty(varargin)
        nElems = length(obj.elements);
      else
        elemIds = mp_gmsh_elems_find(obj.elements, varargin{1});
        nElems = length(elemIds);
      end  
    end
  end
  methods(Access=private)
    function Vertex2Vertex(obj)
      n = length(obj.nodes);
      targets=mat2cell((1:n)', ones(n,1))';
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
      V = mp.Topo(0);
      C = mp.Topo(d);
      if isempty(obj.adjacencies{C+1,V+1})
        obj.updateAdjacency(C,V);
      end
      obj.adjacencies{V+1, C+1} = obj.adjacencies{C+1, V+1}.inverse();      
    end
    function Vertex2Cell(obj)
      error('Not implemented')
    end
    function Edge2Vertex(obj)
      d = obj.dim;
      if d > 2
        error('Not implemented')
      end
      adj = obj.getAdjacency(mp.Topo.F, mp.Topo.V);
      D=[];
      for i = adj.getSources()
        elemEdges = mp_gmsh_element_edges(obj.elements{obj.faces2elements(i)});
        for e=elemEdges
          D = [D; e{:}];
        end
      end
      D = sort(D, 2);
      D = unique(D, 'rows');
      targets = mat2cell(D, ones(size(D,1),1))';
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
        adjedges = [];
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
      e2v = obj.getAdjacency(1, 0);
      v2f = obj.getAdjacency(0, 2);
      f2v = obj.getAdjacency(2, 0);
      nedges = e2v.length;
      targets = cell(1, nedges);
      for i=1:nedges
        v = e2v.at(i);
        faces = v2f.at(v(1));
        ef = [];
        for f = faces
          fv = f2v.at(f);
          if ismember(v(2), fv)
            ef = [ef, f];
          end
        end
        assert(length(ef) <= 2 && length(ef) > 0)
        targets{i} = ef;
      end
      obj.adjacencies{2, 3} = mp.Adjacency(targets);
    end
    function Edge2Cell(obj)
      error('Not implemented')
    end
    function Face2Vertex(obj)
      if obj.dim == 2
        elems2D = mp_gmsh_elems_find(obj.elements, struct('dim', 2));
        nelem = length(elems2D);
        adj = cell(1, nelem);
        obj.faces2elements = zeros(1, nelem);
        for i=1:nelem
          nnodes = mp_gmsh_node_count(obj.elements{elems2D(i)}(2));
          obj.faces2elements(i) = obj.elements{elems2D(i)}(1);
          adj{i} = obj.elements{elems2D(i)}(end-nnodes+1:end);
        end  
        obj.adjacencies{3,1} = mp.Adjacency(adj);
      end
     end
    function Face2Edge(obj)
      d = obj.dim;
      if d > 2
        error('Not implemented for dimension 3')
      end
      adj = obj.getAdjacency(1,2);
      obj.adjacencies{3,2} = adj.inverse();
    end
    function Face2Face(obj)
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
      error('Not implemented')
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
      updaters{2,1} = @obj.Edge2Vertex; 
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
