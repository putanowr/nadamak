%% Plot elements of 2D mesh
%
function [handle] = mp_plot_edges(nodes, elements, varargin)
  tpd = mp_gmsh_types_per_dim();
  if nargin > 2
    selector = varargin{1};
  else
    selector = struct();
  end
  selector.type = [tpd{2}];
  elem2D = mp_gmsh_elems_get(elements, selector);
  connectivity = mp_gmsh_elems_connectivity(elem2D);
  nnodesMax = max(cellfun(@length, connectivity(:,2)));
  nelems = size(connectivity,1);
  faces = ones(nelems, nnodesMax)*nan;
  facesId = cell2mat(connectivity(:,1))';
  colors = ones(nelems, 1);
  for i=1:nelems
    n = length(connectivity{i, 2});
    faces(i, 1:n) = connectivity{i, 2};
    if elem2D{i}(3) > 0
      colors(i) = elem2D{i}(4);
    end
  end
  S.Faces = faces;
  if isa(nodes, 'mp.SharedArray')
    S.Vertices = nodes.Data;
  else
    S.Vertices = nodes;
  end
  S.FaceColor = 'none';
  S.EdgeColor = 'green';
  handle = patch(S); 
  set(handle, 'UserData', facesId);
end
