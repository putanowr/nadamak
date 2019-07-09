clear all
geom = mp.geoms.SquareGeom('mydomain');
geom.regions()
mesher = mp.Mesher();
meshparams.transfinite=true;
meshparams.transres=[3,3];
meshparams.quadsonly=true;
meshparams.lc = 0.1;

mesh = mesher.generate(geom, meshparams);

viewer = mp.Viewer();
viewer.show(mesh);

problem = mp.kernel.calfem.MechanicalProblem(geom);
problem.registerMesh(mesh, 'mainmesh');
problem.setBc('b_south', mp.BcFactory.produce('FixityY', 'Displacement'));
problem.setBc('b_west', mp.BcFactory.produce('FixityX', 'Displacement'));
bc.value = [0.0, 0.5];
problem.setBc('b_nort', mp.BcFactory.produce('Displacement', 'Displacement', bc));

problem.solve(struct());
varName = 'Displacement';

var = problem.model.variables.get(varName);
nnodes = var.fem.mesh.countNodes();
disp('Nodes to dofs')
var.fem.nodes2dofs
val = var.dofValues(var.fem.nodes2dofs)
d = reshape(val, var.variable.qdim, nnodes)';
viewer.stackFigure();
kk = zeros(size(d,1), 3);
kk(:, 1:2) = d;
viewer.show(mesh, struct('Displacement', kk));
viewer.labelNodes();
disp('Nodal displacement')
disp(d)
mesh = problem.model.meshes.get('mainmesh')
mesh.elemNodes(13)
mesh.elemNodes(14)
mesh.elements{13}