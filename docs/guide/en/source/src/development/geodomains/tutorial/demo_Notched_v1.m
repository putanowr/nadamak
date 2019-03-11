mesher = mp.Mesher();

geom = mp.geoms.NotchedRQGeom('my_domain');

mesh = mesher.generate(geom, struct('lc', 0.8));

viewer = mp.Viewer();
viewer.show(mesh);
