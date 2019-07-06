function writePressureLoads(fid, mesh, bc)
function writePrescribedDispacements(fid, mesh, bc)
  % Write portion of FlagSHyp input file related to pressure loadds
  selector = mp.makeBcRegionsSelector(obj.bc, mp.BcType.Pressure, 'Displacement');
  for regname = selector.name
    bcond = bc.get(regname, 'Displacement');
    elems = mesh.findRegionElements(struct('name', regname));
    vecFormat.format = '%d';
    vecFormat.separator = ' ';
    vecFormat.newline = false;
    for i = 1:numel(elems) 
      fprintf(' %d', i);
      mp_write_vector(mesh.elemNodes(elems(i), nan, vecFormat));
      fprintf(' %f\n', bcond.value);
    end
  end
end
