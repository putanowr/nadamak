function Nb = sfTriang3(refPoint)
  % Shape functions for classical linear Lagrangian triangle element
  x = refPoint(:,1);
  y = refPoint(:,2);
  Nb = [1-x-y, x, y];
end 
