function N = evalShapeFunctions(femType, refPoint, qdim)
%% Return vecotr of shape function values at refPoint.
% For vector elements specify qdim > 1. The ordering of elements is
% the following: [N_1,N_2,...,N_n,N_1,N_2,...,N_n,...]
% 
  switch femType
    case mp.FEM.FemType.Tri3
      Nb = sfTri3(refPoint);
    case mp.FEM.FemType.Tri6
      Nb = sfTri6(refPoint);
    case mp.FEM.FemType.Quad4
      Nb = sfQuad4(refPoint);
  end 
  N = repmat(Nb, 1, qdim);
end
