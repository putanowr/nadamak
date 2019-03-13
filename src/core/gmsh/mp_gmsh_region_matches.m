%% Check if region record matches given selection criteria.
%
function [res] = mp_gmsh_region_matches(regionrec, selector)
  in = struct('dim', true, 'id', true, 'name', true, 'regexp', true);
  for key = {'dim', 'id'}
    k = key{:};
    if isfield(selector, k)
      in.(k) = ismember(regionrec.(k), selector.(k)(:));
    end  
  end
  if isfield(selector, 'regexp')
    in.regexp = ~isempty(regexp(regionrec.name, selector.regexp, 'once'));
  end  
  if isfield(selector, 'name')
     check = false;
     for name = selector.name
       if ~iscellstr(selector.name)
         error('Selector has to be cell array of strings.')
       end
       if ~isempty(regexp(regionrec.name, name{:}, 'once'))
         check = true;
         break;
       end
     end
     in.name = check;
  end
  res = in.dim && in.regexp && in.name && in.id;
end