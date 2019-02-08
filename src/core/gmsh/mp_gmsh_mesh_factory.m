%% Generate some predefined meshes
%
function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory(name)
  persistent generators
  if isempty(generators)
    generators.meshA = @mp_gmsh_mesh_factory_A;
    generators.meshB = @mp_gmsh_mesh_factory_B;
    generators.meshC = @mp_gmsh_mesh_factory_C;
    generators.meshD = @mp_gmsh_mesh_factory_D;
    generators.meshE = @mp_gmsh_mesh_factory_E;
    generators.meshF = @mp_gmsh_mesh_factory_F;
    generators.square1 = @mp_gmsh_mesh_factory_square1;
    generators.square9 = @mp_gmsh_mesh_factory_square9;
    generators.triangle1 = @mp_gmsh_mesh_factory_triangle1;
    generators.tritri = @mp_gmsh_mesh_factory_tritri;
  end
  [nodes, elements, regions, nodemap] = generators.(name)();
end

function [elements] = mp_make_elements(connectivity, elementName)
  persistent elemTypes
  if isempty(elemTypes)
    elemTypes.triangle = 2;
    elemTypes.quad = 3;
  end
  n = size(connectivity, 1);
  elements = mp.SharedCellArray(n);
  et = elemTypes.(elementName);
  for i=1:n
    elements{i} = int32([i, et, 2, 1, 0, connectivity(i,:)]);
  end            
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_A()
  nodes = [0, 0, 0;
           1, 0, 0;
           2, 0, 0;
           0, 1, 0;
           2, 1, 0];
  connectivity = [1, 2, 4;
                  2, 3, 5;
                  2, 5, 4];
  elements = mp_make_elements(connectivity, 'triangle'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_B()
  nodes = [0, 0, 0;
           3, 0, 0;
           3, 3, 0;
           0, 3, 0;
           1, 1, 0;
           2, 1, 0;
           2, 2, 0;
           1, 2, 0];
  connectivity = [5, 1, 2, 6;
                  6, 2, 3, 7;
                  7, 3, 4, 8;
                  8, 4, 1, 5];
  elements = mp_make_elements(connectivity, 'quad');
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_C()
  nodes = zeros(16,3);
  for i=1:4
    nodes((1:4)+(i-1)*4, 1) = (0:3)';
    nodes((1:4)+(i-1)*4, 2) = [1;1;1;1]*(i-1);
  end 
  connectivity = [1, 2, 6, 5;
                  2, 3, 7, 6;
                  3, 4, 8, 7; 
                  5, 6, 10, 9;
                  7, 8, 12, 11;
                  9, 10, 14, 13;
                  10, 11, 15,14;
                  11, 12, 16, 15];
  elements = mp_make_elements(connectivity, 'quad'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_D()
  nodes = zeros(9,3);
  for i=1:3
    nodes((1:3)+(i-1)*3, 1) = (0:2)';
    nodes((1:3)+(i-1)*3, 2) = [1;1;1]*(i-1);
  end 
  nodes(9,:) = [];
  connectivity = [1, 2, 5, 4;
                  2, 3, 6, 5;
                  4, 5, 8, 7]; 
  elements = mp_make_elements(connectivity, 'quad'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_E()
  nodes = zeros(9,3);
  for i=1:3
    nodes((1:3)+(i-1)*3, 1) = (0:2)';
    nodes((1:3)+(i-1)*3, 2) = [1;1;1]*(i-1);
  end 
  nodes(9,:) = [];
  connectivity = [1, 2, 5;
                  2, 3, 6;
                  1, 5, 4; 
                  2, 6, 5;
                  4, 5, 7;
                  5, 8, 7];
  elements = mp_make_elements(connectivity, 'triangle');
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_F()
  nodes = [0,0,0;
           1,0,0;
           2,0,0;
           3,0,0;
           0,1,0;
           1,1,0;
           2,1,0;
           3,1,0];
  elements = {[1,3,2, 1, 0, 1, 2, 6, 5],
              [2,2,2, 1, 0, 2, 3, 7],
              [3,2,2, 1, 0, 2, 7, 6],
              [4,3,2, 1, 0, 3, 4, 8, 7]};
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_square9()
  nodes = zeros(16,3);
  for i=1:4
    nodes((1:4)+(i-1)*4, 1) = (0:3)';
    nodes((1:4)+(i-1)*4, 2) = [1;1;1;1]*(i-1);
  end 
  connectivity = int32([1, 2, 6, 5;
                  2, 3, 7, 6;
                  3, 4, 8, 7; 
                  5, 6, 10, 9;
                  6, 7, 11, 10;
                  7, 8, 12, 11;
                  9, 10, 14, 13;
                  10, 11, 15,14;
                  11, 12, 16, 15]);
  elements = mp_make_elements(connectivity, 'quad'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_square1()
  nodes = zeros(4,3);
  for i=1:2
    nodes((1:2)+(i-1)*2, 1) = (0:1)';
    nodes((1:2)+(i-1)*2, 2) = [1;1]*(i-1);
  end 
  connectivity = int32([1, 2, 4, 3]);
  elements = mp_make_elements(connectivity, 'quad'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_triangle1()
  nodes = [0, 0, 0;
           1, 0, 0;
           0, 1, 0];
  connectivity = int32([1, 2, 3]);
  elements = mp_make_elements(connectivity, 'triangle'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end

function [nodes, elements, regions, nodemap] = mp_gmsh_mesh_factory_tritri()
  a = 1;
  h = sqrt(3)*a/2;
  a2 = a/2;
  h2 = h/2;
  h4 = h/4;
  a4 = a/4;
  nodes = [0,        0,  0;
           a2,       0,  0;
           a,        0,  0;
           a2-a4/2, h4,  0;
           a2+a4/2, h4,  0;
           a4,      h2,  0;
           a2,      h2,  0;
           a2+a4,   h2,  0;
           a2,      h,   0];
   connectivity = int32([1, 2, 4; 
                         2, 5, 4;
                         2, 3, 5;
                         1, 4, 6;
                         4, 5, 7;
                         4, 7, 6;
                         5, 8, 7;
                         5, 3, 8;
                         6, 7, 9;
                         7, 8, 9]);
  elements = mp_make_elements(connectivity, 'triangle'); 
  regions = struct('dim', 2, 'id', 1, 'name', 'domain');
  nodemap=1:size(nodes,1);
end
