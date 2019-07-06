function writePrescribedDispacements(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to point loadds
  selector = mp.makeBcRegionsSelector(obj.bc, mp.BcType.Displacement, 'Displacement');
  vecFormat.format='%d';
  vecFormat.newline=true;
  for regname = selector.name
    bcond = bc.get(regname, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', regname));
    for n = nodes
      for d = 1:mesh.ambientDim
        fprintf('%d %d %f\n', n, d, bcond.value(d))
      end
    end
  end
end
