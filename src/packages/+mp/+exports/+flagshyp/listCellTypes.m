function listCellTypes(varargin)
  % listCellTypes - display information about cell types suppoerte by
  % FlagSHyp export. 
  % By default the function prints names of FlagSHyp cell types followed
  % by GMSH numberic cell type id.
  % The optiona arguments are pair of name, value with the following:
  %    'fid', integer  - writes to file descriptor instead to stdout
  %    'description', bool - write also element description
  opts = cell2struct(varargin(2:2:end),varargin(1:2:end),2);
  vt = mp.exports.flagshyp.validCellTypes();
  fid = mp_get_option(opts, 'fid', 1);
  for t = vt.keys
    ti = t{1};
    info = mp_gmsh_types_info(ti);
    fprintf(fid, '%s --> %d', vt(ti), info.type);
    printDescription = mp_get_option(opts, 'description', false);
    if printDescription
      fprintf(fid, ' : %s', info.description);
    end
    fprintf(fid, '\n');
  end
end