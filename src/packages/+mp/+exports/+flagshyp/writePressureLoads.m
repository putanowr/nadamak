function writePressureLoads(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to pressure loadds
  fprintf(fid, 'pressure load\n');
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Pressure, 'Displacement');
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    elems = mesh.findRegionElements(struct('name', {regname}));
    vecFormat.format = '%d';
    vecFormat.separator = ' ';
    vecFormat.newline = false;
    for i = 1:numel(elems) 
      fprintf(fid, '%d ', i);
      mp_write_vector(fid, mesh.singleElemNodes(elems(i)), nan, vecFormat);
      fprintf(fid, ' %f\n', bcond.value);
    end
  end
end
