function [elemCount] = countPressureElements(mesh, bc)
  % Return number of elements with pressure boundary conditions 
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Pressure, 'Displacement');
  elemCount = 0;
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    elems = mesh.findRegionElements(struct('name', {regname}));
    elemCount = elemCount + numel(elems);
  end
end  
