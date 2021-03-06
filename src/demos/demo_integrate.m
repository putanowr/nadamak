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
meshingparams.order = 3;
mesh = mesher.generate(geom, meshingparams);

%% Selecting nodes
selector.b_south = 0;
selector.b_north = 0;
selector.b_west = 0;
selector.b_east = 0;

nodesTag = mp_tag_region_nodes(mesh, selector, 'min', 1);
boundaryNodes = find(nodesTag==0);
internalNodes = find(nodesTag==1);

boundaryPts = mesh.nodes(boundaryNodes, :);

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

radius = 0.1*radius;
radius(boundaryNodes) = 0.0;
direction = 2*pi*rand(mesh.nodesCount(), 1);
distance = radius.*(0.5+0.5*rand(mesh.nodesCount(),1));
u = distance.*[cos(direction), sin(direction)];

gmap = mesh.geomTrans();
quadrature = mp.IM.Triangle(4);

s = 0.0;
for i=1:mesh.perDimCount(mesh.dim)
  J = gmap.jacobian(quadrature.pts, i, u);
  for k=1:numel(quadrature.w)
    j = det(J(:,:,k));
    s = s+j*quadrature.w(k);
  end
end

fprintf('Integral : %g\n', s);

% Report demo status
mp_manage_demos('report', 'integrate', true);
