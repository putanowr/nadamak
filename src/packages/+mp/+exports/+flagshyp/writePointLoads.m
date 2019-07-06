function writePointLoads(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to point loadds
  selector = mp.makeBcRegionsSelector(obj.bc, mp.BcType.Force, 'Displacement');
  vecFormat.format='%d';
  vecFormat.newline=true;
  for regname = selector.name
    bcond = bc.get(regname, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', regname));
    for n = nodes
      fprintf('%d ', n)
      mp_write_vector(fid, bcond.value, mesh.ambientDim, vecFormat);
    end
  end
end