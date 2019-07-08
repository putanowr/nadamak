function writePrescribedDisplacements(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to point loadds
  fprintf(fid, 'Prescribed displacement\n');
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Displacement, 'Displacement');
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', {regname}));
    for n = nodes
      for d = 1:mesh.ambientDim
        if ~ismissing(bcond.value(d))
          fprintf(fid, '%d %d %f\n', n, d, bcond.value(d));
        end  
      end
    end
  end
end
