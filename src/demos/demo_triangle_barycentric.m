%% Triangular higher order elements 

% 
clear variables;

%% Create object describing geometric model
geom = mp.geoms.TriangleGeom('my_domain');
lc = geom.coarsest_lc();

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.showGeometry(geom);

geom.vertices()
pts = mp_triangle_points(geom.vertices(), 10, 5);

viewer.showPoints(pts);

viewer.stackFigure();

geom.params.A = [0.5,0];
geom.params.B = [3,1];
geom.params.C = [2,2];

viewer.showGeometry(geom);
pts = mp_triangle_points(geom.vertices(), 10, 5);
viewer.showPoints(pts);

%%
mp_manage_demos('report', 'triangle_barycentric', true);
