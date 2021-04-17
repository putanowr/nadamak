%% Read data into array of region structures. 
function [nodes, nodemap] = mp_gmsh_read_nodes(fid_or_name, version)
  arguments
      fid_or_name
      version (1,1) uint32 = 4
  end
  if version == 4
    [nodes, nodemap] = local_read_nodes_ver_4(fid_or_name);
  elseif version == 2
    [nodes, nodemap] = local_read_nodes_ver_2(fid_or_name);
  else
    error("Invalid msh version %d", version)
  end
end

function [nodes, nodemap] = local_read_nodes_ver_4(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Nodes');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  data = sscanf(tline, '%d');
  numEntityBlocks = data(1);
  numNodes = data(2);
  minNodeTag = data(3);
  maxNodeTag = data(4);
  nodes = zeros(numNodes, 3);
  nodemap = zeros(numNodes, 1);
  is = 0;
  ie = 0;
  for i = 1:numEntityBlocks
      tline = fgetl(fid);
      disp(tline)
      data = sscanf(tline, '%d', [4])
      disp('HERE')
      entityDim = data(1);
      entityTag = data(2);
      hasParamCoords = data(3);
      numNodesInBlock = data(4);
      if numNodesInBlock > 0
        is=ie+1;
        ie=is+numNodesInBlock-1;
        data = fscanf(fid, '%d', [1, numNodesInBlock]);
        nodemap(is:ie,1) = data';
        if hasParamCoords
          data = fscanf(fid, '%f', [6, numNodesInBlock]);
        else
          data = fscanf(fid, '%f', [3, numNodesInBlock]);
        end
        nodes(is:ie,:) = data(1:3,:)';
        fgetl(fid);
      end  
  end
  mp_read_end_section(fid, '\$EndNodes');
  if needclose
    fclose(fid);
  end
end

function [nodes, nodemap] = local_read_nodes_ver_2(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Nodes');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  data = fscanf(fid, '%f', [4, n]);
  nodes = zeros(n, 3);
  nodemap = zeros(n, 1);
  nodes = data(2:4,:)';
  nodemap = data(1,:)';
  fgetl(fid); % This call is to consume new line character
  mp_read_end_section(fid, '\$EndNodes');
  if needclose
    fclose(fid);
  end
end
