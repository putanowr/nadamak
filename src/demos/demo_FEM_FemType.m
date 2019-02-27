%% Types of Finite Elements

%% Demo contents
% 
% This demo illustrates how to get information about type of finite elements
% supported by Nadamak.

clear variables;

%% Types of finite elements
%
% Finite elemet types are managed by enumeration class mp.FEM.FemTypes.
%
enumeration('mp.FEM.FemType')

fem = mp.FEM.FemType.Triang6;

fprintf('Information about FEM type: %s\n', fem);
fprintf('  GMSH element id: %d\n', fem.gmshID);
fprintf('  is Lagrangaian: %d\n', fem.isLagrangian);
fprintf('  order : %d\n', fem.order);
fprintf('  number of DOFs: %d\n', fem.numOfDofs);
fprintf('  ------------------------\n')
fprintf('  Node coordinates in reference element: \n');
disp(fem.dofsCoords());
fprintf('  Dofs on element entities\n');
dofstopo = fem.dofsTopo;
for i=1:size(dofstopo, 1)
    fprintf('     Dof idx: %d   entity dim: %d  entity local id: %d\n', ...
        i, dofstopo(i,1), dofstopo(i,2));
end

%%
mp_manage_demos('report', 'FEM_FemType', true);
