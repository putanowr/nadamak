%% Viewer demo

%% Illustrate meshing LShapeGeom with various mesh densities
% 
% The LShapeGeom class provides convenient object oriented interface for
% managing L-shape geometry model.

clear variables;

%% Create object describing geometric model
geom = mp.geoms.LShapeGeom('my_domain');
geom.params.dW = 3;
geom.params.dt = 1.2;
%%
% <<images/tmp_LShape.png>>

%% Create viewer
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.showGeometry(geom);
selector.region = {'bottom'};
viewer.highlight_elements(selector);

%%
mp_manage_demos('report', 'Viewer', true);
