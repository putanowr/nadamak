function Nb = sfTriang6(refPoint)
% Shape functions for classical quadratic Lagrangian triangle element
% It is assumed that reference element is in normalized coordinates.
  x = refPoint(:,1);
  y = refPoint(:,2);
  z = 1 - x - y;
  Nb = [x.*(x-z-y), y.*(y-x-z),z.*(z-y-x),4*x.*y,4*y.*z,4*x.*z];
end
