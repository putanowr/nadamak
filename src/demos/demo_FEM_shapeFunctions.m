%% Shape functions for Triang10 element

%% Demo contents
% 
% This demo illustrates how to calculate value of shape functions for Triang10
% element.

clear variables;

%% Type of finite elements
%
% Finite elemet types are managed by enumeration class mp.FEM.FemTypes.
%

for fem = enumeration('mp.FEM.FemType')'
  fprintf('Fem type: %s\n', fem)
  xy = fem.dofsCoords();

  N = fem.sfh(xy);

  %%
  % Display matrix of shape functions at nodes coloriing the values.
  mp_disp_sf_matrix(N, 5, 2);

  fprintf('----------------------------------------\n');
end

%%
mp_manage_demos('report', 'FEM_shapeFunctions', true);
