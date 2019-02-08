function [outstr] = mp_tpl_substitute(template, context)
% Generate output string by substituting placeholders in template by
% values of fields of context structure. The placeholders are of the
% form '<name>'.
  varNames = fieldnames(context);
  nvars = length(varNames);
  expressions = {};
  replacements = {};
  for i = 1:nvars
    name = varNames{i};
    expressions = [expressions, strcat('<', name, '>')];
    contextval = context.(name);
    if isscalar(contextval)
       val = string(contextval);
    elseif isvector(contextval)
       val = join(string(contextval), ',');
    else
       error('other types than scalar and vector not supported in templates')
    end
    val = strrep(val, 'true', '1');
    val = strrep(val, 'false', '0');
    replacements = [replacements, val];
  end
  outstr = regexprep(template, expressions, replacements);
end
