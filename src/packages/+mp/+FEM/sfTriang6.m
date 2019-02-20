function Nb = sfTriang6(refPoint)
% Shape functions for classical quadratic Lagrangian triangle element
% It is assumed that reference element is in normalized coordinates.
  x = refPoint(:,1);
  y = refPoint(:,2);
  z = 1 - x - y;
  Nb = [z.*(z-y-x), x.*(x-z-y), y.*(y-x-z),4*x.*z,4*y.*x,4*y.*z];
end
