%% Check if element record matches given selection criteria.
%
function [res] = mp_gmsh_element_matches(elrec, selector)
  elem = struct('type', elrec(2), 'region', elrec(4), 'geom', elrec(5));
  in = struct('dim', true, 'type', true, 'region', true, 'geom', true);
  for key = {'type', 'region', 'geom'}
    k = key{:};
    if isfield(selector, k)
      in.(k) = ismember(elem.(k), selector.(k));
    end  
  end
  if isfield(selector, 'dim')
    in.dim = ismember(mp_gmsh_element_dim(elrec), selector.dim);
  end
  res = in.type && in.region && in.geom && in.dim;
end