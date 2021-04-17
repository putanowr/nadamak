%% Illustrate low level interface to GMSH

clear variables;

%% Create object describing geometric model
geom = mp.geoms.SquareGeom('my_domain');

%% Get description of geometric model in GMSH format
s = geom.as_gmsh()

%%
% Investigate and fill free parameters
params = mp_tpl_what_params(s)

params.lc = 0.1;
params.quadsonly = true;
params.transfinite = true;
params.transres = [10, 10];

s = mp_tpl_substitute(s, params)

%% Call GMSH
[status, meshpath, geopath] = mp_gmsh(s, struct())

%% Read mesh data from temporary files
fileread(meshpath);
[major, minor, isascii] = mp_gmsh_read_version(meshpath)
nodes = mp.gmsh.read_nodes(meshpath);
scatter(nodes(:,1), nodes(:,2));
elems = mp.gmsh.read_elements(meshpath);
regions = mp_gmsh_read_regions(meshpath);

%% Internal management of demo
mp_manage_demos('report', 'gmsh_low_level', true);

