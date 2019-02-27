%% Calculate and highlight elements centers
%
%% Define geometry
geom = mp.geoms.SquareGeom('mydomain', struct());

%% Generate mesh
mesher = mp.Mesher();
mesh = mesher.generate(geom, struct('lc', 0.4));

viewer = mp.Viewer();
viewer.show(mesh);

%% Calculate elements centers
%
%% 
% Pre-allocate vectors for element centers for efficiency reason
elemsSelector.dim = 2;
nElems2D = mesh.elemsCount(elemsSelector)
x2 = zeros(1, nElems2D); y2 = x2;
elemsSelector.dim = 1;
nElems1D = mesh.elemsCount(elemsSelector)
x1 = zeros(1, nElems1D); y1 = x1;
% Set countes of 1D and 2D elements to zero
i1=0;
i2=0;
%%
% Iterate over elements of dimension 1 or 2
elemsSelector.dim = [1,2];
for e = mesh.findElems(elemsSelector)
  elemNodes = mesh.elemNodes(e);
  elemCoords = mesh.nodes(elemNodes,:);
  nnodes = size(elemCoords, 1);
  center = sum(elemCoords, 2)/nnodes;
  xc = sum(elemCoords(:, 1))/nnodes;
  yc = sum(elemCoords(:, 2))/nnodes;
  if nnodes == 3
    i2 = i2+1;
    x2(i2) = xc;
    y2(i2) = yc;
  elseif nnodes == 2  
    i1 = i1+1; 
    x1(i1) = xc;
    y1(i1) = yc;
  end
end  
%% Draw points at element centers
viewer.pointColor = 'cyan';
viewer.showPointsXY(x2,y2);
viewer.pointColor = 'red';
viewer.showPointsXY(x1, y1);

mp_manage_demos('report', 'mp_elems_centers', true);
