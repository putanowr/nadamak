function writeLoadingData(fid, mesh, bc, grav)
  % Write loading data header
  nlpds = mp.countPointLoadNodes(mesh, bc);
  nprs = mp.countDisplacedDofs(mesh, bc);
  nbpel = mp.countPressureElements(mesh, bc);
  fprintf(fid, '%d %d %d ', nlpds, nprs, nbpel);
  vecFormat.format = '%f';
  mp_write_vector(fid, grav, mesh.ambientDim, vecFormat)
end
