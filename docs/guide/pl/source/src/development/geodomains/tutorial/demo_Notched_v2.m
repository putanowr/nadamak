mesher = mp.Mesher();

geom = mp.geoms.NotchedRQGeom('my_domain');
geom.params.dR = 0.5;
geom.params.dH = 1;

mesh = mesher.generate(geom, struct('lc', 0.1));

viewer = mp.Viewer();
viewer.show(mesh);
