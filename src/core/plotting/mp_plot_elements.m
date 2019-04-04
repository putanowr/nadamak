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
    type = mp_gmsh_element_type(elems{i});
    rf = remap(connectivity{i, 2}, type);
    faces(i, 1:numel(rf)) = rf;
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
function con = remap(C, elemType)
  switch elemType
    case 9
      i = [1,4,2,5,3,6];
      con = C(i);
    case {10, 16}
      i = [1,5,2,6,3,7,4,8];
      con = C(i);
    otherwise
      con = C;
  end
end
