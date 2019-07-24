function cmps = mp_parse_components(params, range)
  % Return row vector of indices by parsing structure field named 'components'
  % If such field is missing return 1:range
  % The 'components' field can be
  %     'all' string - returns 1:range
  %     string of indices separated by space,coma, semicolon
  %     row vector of indices
  %     nan - returns 1:range
  %     [] - returns 1:range
  cmps = mp_get_option(params, 'components', nan);
  if ischar(cmps)
    if strcmpi(cmps, 'all')
      cmps = nan;
    else
      cmps = rmmissing(str2double((split(cmps,...
                  {'[',']',',', ' ', ';'}))))';
    end
  end
  if isempty(cmps)
    cmps = nan;
  end
  if ismissing(cmps)
     cmps = range;
  end
  cmps = cmps(:)'; % make sure it is row vector
end
