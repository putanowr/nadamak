%% Return number of nodes per given element type.
% TODO : finish documentation
function [count] = mp_gmsh_node_count(type)
  persistent node_count_per_type 
  if isempty(node_count_per_type)
    node_count_per_type = [
           2;
           3;
           4;
           4;
           8;
           6;
           5;
           3;
           6;
           9;
          10;
          27;
          18;
          14;
           1;
           8;
          20;
          15;
          13;
           9;
          10;
          12;
          15;
          15;
          21;
           4;
           5;
           6;
          20;
          35;
          56;
          ((32:91)*0)';
          64;
          125;
          ((94:504)*0)'
          (5:16)' % Polygonal elements
         ];
    end
  count = node_count_per_type(type);
end 
