function writeMesh(mesh,fid)
  % Write mp.Mesh in FLagSHyp format
  if ~mesh.isSingleElemType()
    ME = MException('mp.exports.flashyp:mixedMeshTypes', ...
                    'Mesh object is not of single element type');
    throw(ME);
  end       
  ct = mesh.cellTypes();
  fprintf(fid, '%s\n', flagshypCellType(ct));
  outputArg2 = inputArg2;
end

function fct = flashypCellType(ct)
  persistent validTypes
  if isempty(velidTypes)
    validTypes = mp.exports.flagshyp.validCellTypes)
  end
  fct = validTypes(ct)
end



