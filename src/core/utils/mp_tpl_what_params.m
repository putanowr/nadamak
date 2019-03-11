function [params] = mp_tpl_what_params(template)
% Generate context structure from a template, that is the structure with 
% field names that correspond to unbounded parameters of the template.
% The unbounded parameters of a template has the form '<name>'.
  pat = '<(?<name>\w+)>';
  tokens = regexp(template, pat, 'names');
  params = struct();
  for token=tokens
    name = token.name;
    if ~isfield(params, name)
       params.(name) = [];
    end
  end
end  