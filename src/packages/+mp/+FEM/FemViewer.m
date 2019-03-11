classdef FemViewer < handle
  % The purpose of this class it to display information about FEM
  % element types as defined by class mp.FEM.FemType.
  properties(Access=private)
      fig; 
      handles = struct();
      bbox = [0,1,0,1];
  end
  methods
    function [self] = FemViewer()
      self.fig = figure('Name', 'FEM Viewer');
    end 
    function show(self, femType)
      ft = mp.FEM.FemType(femType);
      hold on
      self.drawOutline(ft)
      self.drawNodes(ft)
      axis(self.bbox);
      axis('equal');
    end
  end
  methods(Access=private)
    function drawOutline(self, ft)
      info = mp_gmsh_types_info(ft.gmshID);
      xy = [];
      for e=info.edges
        xy = [xy; info.nodes(e{:}, :)];
      end
      minC = min(xy);
      maxC = max(xy);
      span = maxC-minC;
      margin =0.1; 
      self.bbox = [minC(1), maxC(1), minC(2), maxC(2)]+margin*[-span(1),span(1),-span(2),span(2)]
      self.handles.outline = line(xy(:,1), xy(:,2));
    end
    function drawNodes(self, ft)
      info = mp_gmsh_types_info(ft.gmshID);
      self.handles.nodes = mp_plot_nodes(info.nodes);
      mp_plot_labels(self.handles.nodes, struct('xOffset', 0.02, 'yOffset', 0.02));
    end
  end 
end
