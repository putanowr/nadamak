function [mapper] = makeBcMapper(bcRegistry)
  % Return mapper for boundary conditions. Mapper is a structure
  % that maps region names to numeric tags. The values of numeric tags
  % depend on the boundary conditions specified on the regions.
  rn = bcRegistry.regionNames();
  mapper = struct();
  for regionName = rn
    bc = bcRegistry.get(regionName{:},'Displacement');
    mapper.(regionName{:}) = mp.exports.flagshyp.bc2tag(bc.type);
  end
end