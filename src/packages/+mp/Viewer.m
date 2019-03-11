classdef Viewer < handle
  % Manages mesh generation process 
  properties(Access=private)
      mesh;
      fig; 
      handles;
      stacked;
  end
  properties(Access=public)
    pointColor = 'red';
    lineColor = 'yellow';
    showCellEdges = true;
    edgeLabelColor = 'blue';
    showNodes = true;
    pointSize = 20;
  end
  methods
    function [obj] = Viewer()
        obj.mesh = [];
        obj.fig = figure('Name', 'Mesh Viewer');
        obj.stacked = {};
    end 
    function unstackFigure(obj, n)
      if n > length(obj.stacked)
        error('Invalid index n=%d for stacked figure', n);
      end
      close(obj.fig)
      obj.fig = obj.stacked{n}{1};
      obj.mesh = obj.stacked{n}{3};
      obj.handles = obj.stacked{n}{2};
      obj.stacked(n) = [];
    end
    function [n] = stackFigure(obj)
       n = length(obj.stacked)+1;
       obj.stacked{n} = {obj.fig, obj.handles, obj.mesh};
       obj.fig = figure('Name', 'Mesh Viewer');
       obj.handles = struct();
       obj.mesh = [];
    end
    function show(obj, mesh, varargin)
      figure(obj.fig);
      obj.mesh = mesh;
      params = struct('dim', obj.mesh.dim, 'showNodes', obj.showNodes);
      if ~isempty(varargin)
         params.dim = mp_get_option(varargin{1}, 'dim', params.dim);
      end
      obj.handles = mp_plot_mesh(mesh.nodes, mesh.elements, params);
      if obj.showCellEdges 
        obj.handles.edges = mp_plot_edges(mesh.nodes, mesh.elements);
      end
      axis('equal');
    end
    function showGeometry(obj, geomObj)
      mesher = mp.Mesher();
      params.lc = geomObj.coarsest_lc()/10;
      params.dim = 1;
      locmesh = mesher.generate(geomObj, params);
      obj.showCellEdges = false;
      figure(obj.fig);
      obj.mesh = locmesh;
      obj.handles.elements = mp_plot_edges(locmesh.nodes, locmesh.elements, struct('dim', obj.mesh.dim)); 
      axis('equal')
    end
    function showStar2(obj, mesh, seedsDim, seeds, starDims, starDims2, options)
      if nargin < 7
        options = struct('ShowSeeds', true);
      end
      figure(obj.fig);
      for sd = starDims
        adj = mesh.getAdjacency(mp.Topo(seedsDim), mp.Topo(sd));
        e2n = mesh.getAdjacency(mp.Topo(sd), mp.Topo(0));
        for s = seeds
          for e=adj.at(s)
            nodes = e2n.at(e);
            obj.drawStarItem(mesh, sd, nodes, false);
            obj.showStar(mesh, sd, e, starDims2, struct('ShowSeeds', false));
          end
        end
      end
      if mp_get_option(options, 'ShowSeeds', true)
        obj.drawSeeds(mesh, seedsDim, seeds);
      end
    end
    function showStar(obj, mesh, seedsDim, seeds, starDims, options)
      if nargin < 6
        options = struct('ShowSeeds', true);
      end      
      figure(obj.fig);
      for sd = starDims
        adj = mesh.getAdjacency(mp.Topo(seedsDim), mp.Topo(sd));
        e2n = mesh.getAdjacency(mp.Topo(sd), mp.Topo(0));
        for s = seeds
          for e=adj.at(s)
            nodes = e2n.at(e);
            obj.drawStarItem(mesh, sd, nodes, false);            
          end
        end
      end
      if mp_get_option(options, 'ShowSeeds', true)
        obj.drawSeeds(mesh, seedsDim, seeds);
      end
    end

    function labelNodes(obj, varargin)
      figure(obj.fig)
      hold on
      if nargin > 1
        opts = varargin{1};
      else
        opts = struct();
      end
      mp_plot_labels(obj.handles.nodes, opts);
    end
    function labelEdges(obj, varargin)
      figure(obj.fig)
      hold on
      opts = struct();
      if nargin > 1
        if isstruct(varargin{1})
          opts = varargin{1};
        else
          opts.id = varargin{1};
        end
      end
      opts.Color = obj.edgeLabelColor;
      e2v = obj.mesh.getAdjacency(1,0);
      nedges = e2v.length;
      ids = mp_get_option(opts, 'id', 1:nedges);
      coords = zeros(length(ids), 2);
      opts.labels = mp_get_option(opts, 'labels', ids);
      for k=1:length(ids)
         edgeNodes = e2v.at(ids(k));
         nen = length(edgeNodes);
         coords(k, :) = sum(obj.mesh.nodes(edgeNodes, 1:2))/nen;
      end
      mp_plot_labels(coords, opts);
    end
    function labelElements(obj, varargin)
      figure(obj.fig)
      hold on
      if nargin > 1
        opts = varargin{1};
        if isfield(opts, 'asFaces') && opts.asFaces == true
          opts.labels = 1:length(get(obj.handles.elements, 'UserData'));
        end  
      else
        opts = struct();
      end
      mp_plot_labels(obj.handles.elements, opts);
    end
    function showLine(obj, point1, point2, varargin)
      figure(obj.fig);
      hold on
      if nargin > 3
        opts = varargin{1};
      else
        opts = struct();
      end
      x = [point1(1), point2(1)];
      y = [point1(2), point2(2)];
      color = mp_get_option(opts, 'Color', obj.lineColor);
      line(x,y, 'Color', color);
    end
    function showPointsXY(obj, x, y, varargin)
      figure(obj.fig);
      hold on
      opts = struct();
      if ~isempty(varargin)
        opts = varargin{1};
      end
      color = rgb(mp_get_option(opts, 'Color', obj.pointColor));
      ptSize = mp_get_option(opts, 'PointSize', obj.pointSize);
      obj.handles.points = scatter(x,y, ptSize,'filled', 'MarkerFaceColor', color);
      data = mp_get_option(opts, 'UserData', []);
      if ~isempty(data)
        set(obj.handles.points, 'UserData', data);
      end
    end 
    function showPoints(obj, points, varargin)
      opts = struct();
      if ~isempty(varargin)
        opts = varargin{1};
      end
      obj.showPointsXY(points(:,1), points(:,2), opts);
    end 
    function highlight_nodes(obj, selectorOrIds)
      obj.highlightNodes(selectorOrIds);
    end
    function highlightNodes(obj, selectorOrIds)
      hopts.markerColor = 'red';
      hopts.markerFactor = 2;
      if isstruct(selectorOrIds)
        nodes = mp_gmsh_elems_select_nodes(obj.mesh.elements, obj.mesh.regions, selectorOrIds);
      else
        nodes = selectorOrIds;
      end
      mp_highlight_nodes(obj.handles.nodes, nodes, hopts);
    end
    function highlight_elements(obj, selector)
      hopts.elementHiglightColor = 'green';
      hopts.markerFactor = 3;
      hopts.EdgeColor='red';
      if isfield(selector, 'region')
        if iscellstr(selector.region)
          regionsId = mp_gmsh_regions_find_id(obj.mesh.regions, struct('name', {selector.region}), 100);
        else
          regionsId = selector.region;
        end  
        elemIds = mp_gmsh_elems_find(obj.mesh.elements, struct('region', regionsId));
      else
        elemIds = selector; 
      end
      mp_highlight_elements(obj.handles.elements, elemIds, hopts);
    end
    function saveas(obj, filename)
      saveas(obj.fig, filename);
    end
    function clear(obj)
      clf(obj.fig)
    end
  end
  methods(Access=private)
    function drawStarItem(obj, mesh, itemDim, nodes, isSeed)
      figure(obj.fig);      
      x = mesh.nodes(nodes, 1);
      y = mesh.nodes(nodes, 2);
      hold on
      if isSeed
        colors = {'red', 'red', 'red'};
      else  
        colors = {'blue', 'yello', 'green'};
      end
      switch itemDim
        case 0
          h = scatter(x, y, 20, colors{1}, 'filled');
          uistack(h, 'top');
        case 1
          h = line(x,y, 'Color', colors{2}, 'LineWidth', 2);
          uistack(h, 'top');
        case 2
          fill(x,y, colors{3});
       end    
    end
    function drawSeeds(obj, mesh, seedsDim, seeds) 
      if seedsDim == 0
        for s = seeds
          obj.drawStarItem(mesh, 0, s, true);
        end
      else 
        seedsAdj = mesh.getAdjacency(mp.Topo(seedsDim), mp.Topo(0));
        for s = seeds
          nodes = seedsAdj.at(s);
          obj.drawStarItem(mesh, seedsDim, nodes, true);
        end
      end
    end  
  end
end
