%% Calculate and highlight elements centers
%
%% Define geometry
geom = mp.geoms.SquareGeom('mydomain', struct());

%% Generate mesh
mesher = mp.Mesher();
mesh = mesher.generate(geom, struct('lc', 0.4));

viewer = mp.Viewer();
viewer.show(mesh);

%% Get information about cell types
ct = mesh.cellTypes();
if (length(ct) > 1)
  error('This demo assumes mesh of single cell type')
end

info = mp_gmsh_types_info(ct);
center = sum(info.nodes, 1)/info.nnodes

% Calculate number of cells
cellSelector.dim = mesh.dim;
ncells = mesh.elemsCount(cellSelector);

%% Map center of reference element to real element

% Pre-allocate vectors for element centers for efficiency reason
xyz = zeros(ncells, 3);

% Iterate over cells 
for i=1:ncells
  xyz(i, :) = mesh.geomTrans.transform(center, i);
end

%% Draw points at element centers
viewer.pointColor = 'red';
viewer.showPointsXY(xyz(:,1),xyz(:,2));

mp_manage_demos('report', 'mp_GeomTrans', true);
