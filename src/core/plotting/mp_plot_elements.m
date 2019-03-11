%% Plot elements of 2D mesh
% By default this function plots 2D elements. By specifying structure
% of parameters it is possible to force plotting of only 1D elements.
function [handle] = mp_plot_elements(ax, nodes, elements, varargin)
  param.dim = 2;
  if ~isempty(varargin)
    param.dim = mp_get_option(varargin{1}, 'dim', param.dim);
  end
  tpd = mp_gmsh_types_per_dim();
  selector.type = [tpd{param.dim+1}];
  elems = mp_gmsh_elems_get(elements, selector);
  connectivity = mp_gmsh_elems_connectivity(elems);
  nnodesMax = max(cellfun(@length, connectivity(:,2)));
  nelems = size(connectivity,1);
  faces = ones(nelems, nnodesMax)*nan;
  facesId = cell2mat(connectivity(:,1))';
  colors = ones(nelems, 1);
  for i=1:nelems
    n = length(connectivity{i, 2});
    faces(i, 1:n) = connectivity{i,2};
    if elems{i}(2) == 9
      faces(i, 1:n) = remap(connectivity{i, 2});
    end
    if elems{i}(3) > 0  
      colors(i) = elems{i}(4);
    end
  end
  if isa(nodes, 'mp.SharedArray')
    handle = patch(ax, 'Faces', faces, 'Vertices', nodes.Data, 'FaceVertexCData', colors,'FaceColor', 'flat');
  else
    handle = patch(ax, 'Faces', faces, 'Vertices', nodes, 'FaceVertexCData', colors, 'FaceColor', 'flat');
  end
  set(handle, 'UserData', facesId);
end
function con = remap(C)
  if length(C) == 6
    i = [1,4,2,5,3,6];
    con = C(i);
  else
    con = C;
  end
end