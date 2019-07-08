function writePointLoads(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to point loadds
  fprintf(fid, 'Write point loads\n');
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Force, 'Displacement');
  vecFormat.format='%g';
  vecFormat.newline=true;
  selector.name
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', {regname}));
    for n = nodes
      fprintf(fid, '%d ', n);
      mp_write_vector(fid, bcond.value, mesh.ambientDim, vecFormat);
    end
  end
end
