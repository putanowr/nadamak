%% Print formated table of regions' data
% TODO: finish documentation
function mp_gmsh_regions_find(regions, fid)
  fid = mp_get_fid(fid);
  format = '%20s | %3d | %1d\n';
  hformat = '%20s | %3s | %3s';
  s = sprintf(hformat, 'Region name', 'ID', 'dim');
  fprintf(fid,'%s\n%s\n',s,repmat('-', 1, length(s)));
  for i=1:length(regions)
    name = regions(i).name;
    id = regions(i).id;
    dim = regions(i).dim;
    fprintf(fid, format, name, id, dim);
  end
end
