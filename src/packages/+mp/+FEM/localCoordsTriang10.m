function coords = localCoordsTriang10(dofID)
  % Normalized coordinates in reference element corresponding to DOF location.
  % If no dofID is given return the whole array of coordinates. 
  persistent crds 
  if isempty(crds)
    info = mp_gmsh_types_info('type_21');
    crds = info.nodes;
  end
  if nargin < 1 
    coords = crds;
  else
    r = rem(dofID-1,10)+1;
    coords = crds(r, :);
  end
end
