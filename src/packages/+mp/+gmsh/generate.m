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
	[major_version ~, ~] = mp_gmsh_read_version(fid);
    regions = mp_gmsh_read_regions(fid, major_version);
    [nodes, nodemap] = mp.gmsh.read_nodes(fid, major_version);
    elements = mp.gmsh.read_elements(fid, major_version);
    fclose(fid);
  else
    error('Running gmsh has failed'); 
  end
end
