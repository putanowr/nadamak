%% Rerturn cell array of element types per dimension.
%
function [ret] = mp_gmsh_types_per_dim(dim)
  persistent types_per_dim

  if isempty(types_per_dim)
    types_per_dim = { [15];
                      [1,8,26,27,28];
                      [2,3,9,10,16,20,21,22,23,24,25,505:516];
                      [4,5,6,7,11,12,13,14,17,18,19,29,30,31,92,93];
                    };
  end
  if nargin < 1
   ret = types_per_dim;
  else
   ret = types_per_dim(dim+1);
  end
end 
