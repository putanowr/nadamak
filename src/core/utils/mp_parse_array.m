function data = mp_parse_array(str)
  nr = length(find(str==';'));
  str = replace(str, {'Any','any', 'ANY', ',','[',']'}, {'nan', 'nan', 'nan', ' ', '', ''});
  srow = split(str, ';');
  i=1;
  nc = length(sscanf(srow{1}, '%f', inf));
  data = zeros(nr, nc);
  for s = srow'
    data(i, :) = sscanf(s{:}, '%f', inf)';
    i=i+1;
  end
end
