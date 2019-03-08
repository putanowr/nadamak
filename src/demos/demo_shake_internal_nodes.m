%% Illustrate how to randomly shake internal nodes
%
clear variables;
%% Crete Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Create object describing geometric model to be meshed
L = 10;
geom = mp.geoms.SquareGeom('my_domain', struct('da', L));

%% Generate Mesh object
Ne = 5;
meshingparams.lc = L/Ne;
meshingparams.order = 2;
mesh = mesher.generate(geom, meshingparams);

%% Visualize mesh
viewer = mp.Viewer();

viewer.show(mesh);

%% Selecting nodes
selector.b_south = 0;
selector.b_north = 0;
selector.b_west = 0;
selector.b_east = 0;

nodesTag = mp_tag_region_nodes(mesh, selector, 'min', 1);
boundaryNodes = find(nodesTag==0);
internalNodes = find(nodesTag==1);

boundaryPts = mesh.nodes(boundaryNodes, :);

viewer.showPoints(boundaryPts);

radius = L*ones(mesh.nodesCount(), 1);
%% Iterate over elements and calculate maximum allowabel radius
for i=1:mesh.elemsCount() 
  nodes = mesh.elemNodes(i);
  nen = length(nodes);
  pairs = combnk(1:nen, 2);
  for p = pairs'
    n = nodes(p);	  
    nodesDist = norm(diff(mesh.nodes(n,:), 1));
    radius(n) = min(radius(n), nodesDist*[1;1]);
  end	 
end

radius = 0.3*radius;

direction = 2*pi*rand(mesh.nodesCount(), 1)
distance = radius.*(0.5+0.5*rand(mesh.nodesCount(),1));
u = distance.*[cos(direction), sin(direction)];

hold on

for i=1:mesh.nodesCount
  if nodesTag(i)
    xy = mesh.nodes(i, 1:2);
    r = radius(i);
    circle = [xy(1)-r, xy(2)-r, 2*r, 2*r];
    rectangle('Position', circle, 'Curvature', [1,1]);
    xy(end+1,:) = [xy + u(i, :)];
    line(xy(:,1), xy(:,2), 'Color', 'red');
  end
end

mesh.nodes(internalNodes, 1:2) = mesh.nodes(internalNodes, 1:2)+ u(internalNodes, :);

viewer.stackFigure();

viewer.show(mesh);
% Report demo status
mp_manage_demos('report', 'shake_internal_nodes', true);
