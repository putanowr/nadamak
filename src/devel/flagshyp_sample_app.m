clear all
geom = mp.geoms.RectangleIfaceGeom('mydomain');
geom.regions()
geom.params.dH = 2;
mesher = mp.Mesher();
meshparams.transfinite=true;
meshparams.transres=[2,3];
meshparams.quadsonly=true;
meshparams.lc = 0.1;

mesh = mesher.generate(geom, meshparams);

viewer = mp.Viewer();
viewer.show(mesh);
selector.name = {'b_west'}
nodes = mesh.findRegionNodes(selector)
viewer.highlightNodes(nodes)

problem = mp.kernel.nadamak.MechanicalProblem(geom);
problem.registerMesh(mesh, 'mainmesh');
problem.addGravity();
problem.setBc('p_sw', mp.BcFactory.produce('Fixity', 'Displacement'));
bc.value = [missing, 0.025];
problem.setBc('p_sm', mp.BcFactory.produce('Displacement', 'Displacement', bc));
bc.value = [0.02, 0.015];
problem.setBc('p_se', mp.BcFactory.produce('Displacement', 'Displacement', bc));
bc.value = [1.2, 3.4];
problem.setBc('p_ne', mp.BcFactory.produce('Force', 'Displacement', bc));
problem.setBc('p_nm', mp.BcFactory.produce('Fixity', 'Displacement'));
bc.value = 0.25;
problem.setBc('b_left_north', mp.BcFactory.produce('Pressure', 'Displacement', bc));
problem.setBc('b_west',       mp.BcFactory.produce('Pressure', 'Displacement', bc));

problem.exportFlagSHyp('ala.dat') 