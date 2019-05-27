function [count] = mp_gmsh_edges_count(type)
  % Return number of edges per given element type.
  % TODO : finish documentation
  persistent edges_count_per_type 
  if isempty(edges_count_per_type)
    ti = mp_gmsh_types_info();
    types = fieldnames(ti)';
    edges_count_per_type = zeros(numel(types));
    for t = types
      edges = mp_get_option(ti.(t{:}), 'edges', {});
      fprintf ('%s %d\n', ti.(t{:}).description, numel(edges));
      edges_count_per_type(ti.(t{:}).type) = numel(edges);
    end
  end
   count = edges_count_per_type(type);
end 
