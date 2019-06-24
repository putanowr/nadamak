function fct = celllType(gmshCellType)
  % Return string label for FLagSHyp cell type corresponding to
  % gmshCellType
  persistent validTypes
  if isempty(validTypes)
    validTypes = mp.exports.flagshyp.validCellTypes();
  end
  fct = validTypes(gmshCellType);
end