%% Generate mesh by calling GMSH
% 
function [nodes, elements, regions, nodemap] = generate(geoModel, meshingParams)
  doclean = true;
  if isfield(meshingParams, 'clean')
    doclean = meshingParams.clean;
  end 
  [status, meshpath, ~] = mp_gmsh(geoModel, meshingParams);
  if status
    fid = fopen(meshpath, 'r');
    regions = mp_gmsh_read_regions(fid);
    [nodes, nodemap] = mp.gmsh.read_nodes(fid);
    elements = mp.gmsh.read_elements(fid);
    fclose(fid);
  else
    error('Running gmsh has failed'); 
  end
end
