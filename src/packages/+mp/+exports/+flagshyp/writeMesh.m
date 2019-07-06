function writeMesh(fid, mesh, nodeTags)
  % Write mp.Mesh in FLagSHyp format
  if ~mesh.isSingleElemType()
    ME = MException('mp.exports.flashyp:mixedMeshTypes', ...
                    'Mesh object is not of single element type');
    throw(ME);
  end       
  ct = mesh.cellTypes();
  fprintf(fid, '%s\n', mp.exports.flagshyp.cellType(ct(1)));
  fprintf(fid, '%d\n', mesh.countNodes());
  for i=1:mesh.countNodes()
    fprintf(fid, '%d %d ', i, nodeTags(i));
    for d = 1:mesh.ambientDim
      fprintf(fid, ' %f', mesh.nodes(i,d));
    end
    fprintf(fid, '\n');
  end
  ne = mesh.countPerDim(mesh.dim);
  fprintf(fid, '%d\n', ne);
  for i=1:ne
    matid = 1;
    fprintf(fid, '%d %d ', i, matid);
    ei = mesh.elemsFromIds(i);
    nodes = mesh.elemNodes(ei);
    for idx = nodes
      fprintf(fid, ' %d', idx);
    end
    fprintf(fid, '\n');
  end
end
