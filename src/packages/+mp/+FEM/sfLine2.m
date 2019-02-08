function Nb = sfLine2(refPoint)
  % Shape functions for classical linear Lagrangian line element
  x = refPoint(:,1);
  Nb = [1-x, x];
end 