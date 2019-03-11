%% Tag regions nodes 

%% Illustrate tagging region nodes.
% 
clear variables;

%% Create object describing geometric model
geom = mp.geoms.LShapeIfaceGeom('my_domain');
geom.params.dW = 3;
geom.params.dt = 1.2;
geom.params.dH = 4;
%%
% <<images/tmp_LShape.png>>

%% Generate mesh
mesher = mp.Mesher();
mesh = mesher.generate(geom, struct('lc', 0.4));

%% Nodes selector
% Create sturcture with name of the regions that should get explicit tag
% value. In this example all boundary nodes get tag 1 while interface
% nodes get tag 3. 
bcSelector.d_subBottom = 0;
bcSelector.d_subTop = 0;
bcSelector.b_bottom  = 1;
bcSelector.b_left_top = 1;
bcSelector.b_left_bottom = 1;
bcSelector.b_other_bottom = 1;
bcSelector.b_other_top = 1;
bcSelector.i_interface = 3;

%% Get tagging array
% The nodes are tagged acoridng to the specified selector.
% Nodes on region not explicitly selected get tag 0. 
% Conflict resolution is set to default, that means the resolution
% is accorind to a default priority table with labels having the following
% priorities:
% 0->0, 1->100, 2->75, 3->50, 4->25
bc = mp_tag_region_nodes(mesh, bcSelector, 'default', 0);

%% Nodes visualization
% Create colormap
cmap = [0 0 0; 
        1 0 0;
        0 0 1;
        1 0 1];
colormap(cmap);

%%
% Shift the nodes tagging table because in order for the tag values
% to be used as indices in the colormap.
bc=bc+1;

%%
% Draw nodes.
scatter(mesh.nodes(:,1), mesh.nodes(:,2), 20, bc, 'filled');

%%
%
mp_manage_demos('report', 'mp_tag_region_nodes', true);
