function coords = localCoordsQuad4(dofID)
  % Normalized coordinates in reference element corresponding to DOF location.
  % If no dofID is given return the whole array of coordinates. 
  persistent crds 
  if isempty(crds)
    crds = [0.0, 0.0, 0.0;
            1.0, 0.0, 0.0;
            1.0, 1.0, 0.0;
            0.0, 1.0, 0.0];
  end
  if nargin < 1 
    coords = crds;
  else
    r = rem(dofID-1,4)+1;
    coords = crds(r, :);
  end
end
