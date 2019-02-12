function Nb = sfQuad4(refPoint)
% Shape functions for classical Lagrangian quad element
% It is assumed that reference element is in normalized coordinates.
  x = refPoint(:,1);
  y = refPoint(:,2);
  Nb = [(1-x).*(1-y), x.*(1-y),x.*y, y.*(1-x)];
end
