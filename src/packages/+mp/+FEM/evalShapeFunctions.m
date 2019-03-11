function N = evalShapeFunctions(femType, refPoint, qdim)
%% Return vector of shape function values at refPoint.
% For vector elements specify qdim > 1. The ordering of elements is
% the following: [N_1,N_2,...,N_n,N_1,N_2,...,N_n,...]
% 
  switch femType
    case mp.FEM.FemType.Triang3
      Nb = sfTriang3(refPoint);
    case mp.FEM.FemType.Triang6
      Nb = sfTriang6(refPoint);
    case mp.FEM.FemType.Triang10
      Nb = sfTriang10(refPoint);
    case mp.FEM.FemType.Quad4
      Nb = sfQuad4(refPoint);
  end 
  N = repmat(Nb, 1, qdim);
end
