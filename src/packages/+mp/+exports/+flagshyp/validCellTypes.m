function [validTypes] = validCellTypes()
  % Return vector of valid GMSH cell types supported by FlagSHyp
  persistent vt
  if isempty(vt)
    keys = [1, 2, 9, 3, 4, 11, 5]; 
    values = {'truss2', 'tria3', 'tria6', 'quad4', 'tetr4', 'tetr10', 'hexa8'}; 
    vt = containers.Map(keys, values);
  end
  validTypes = vt;
end