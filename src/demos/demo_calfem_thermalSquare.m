%% Run calculations using Calfem package
%

geom = mp.geoms.SquareGeom('mydomain', struct());
problem = mp.Problem();
model = mp.FemModel(geom, problem);

mesher = mp.Mesher();
mesh = mesher.generate(geom, struct('lc', 0.4));
model.meshes.register(mesh, 'main_mesh');

ndofs = mesh.countNodes()

K = zeros(ndofs, ndofs);
f = zeros(ndofs, 1);
  
viewer = mp.Viewer();
viewer.show(model.meshes.get('main_mesh'));

D = eye(2);
ep = [1.0];
i = 1;
for e = mesh.elemsIds(struct('type', 2));
  elemNodes = mesh.elemNodes(e)
  elemCoords = mesh.nodes(elemNodes,:)
  Ke=flw2te(elemCoords(:,1), elemCoords(:,2),ep,D);
  K = assem(elemNodes, K, Ke);
  
end  
hold on
scatter(x,y)
mp_manage_demos('report', 'calfem_thermalSquare', true);
