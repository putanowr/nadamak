function [selector] = makeBcRegionsSelector(bcRegistry, bctype, variable)
  % Return selector (structure) for regions on which specific
  % type of boundary conditions is set.
  rn = bcRegistry.regionNames();
  ca = cell(0,0);
  selector = struct('name', {ca});
  for regionName = rn
    bc = bcRegistry.get(regionName{:}, variable);
    if bc.type == bctype;
      selector.name{end+1} = regionName{:};
    end
  end
end
