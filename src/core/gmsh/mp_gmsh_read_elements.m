%% Read element data into cell array.
% TODO : finish documentation.
function [elements] = mp_gmsh_read_elements(fid_or_name, version)
  arguments
      fid_or_name
      version (1,1) uint32 = 4
  end
  if version == 4
    elements = local_read_elements_ver_4(fid_or_name);
  elseif version == 2
    elements = local_read_elements_ver_2(fid_or_name);
  else
    error("Invalid msh version %d", version)
  end
end

function [elements] = local_read_elements_ver_4(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Elements');
  tline = fgetl(fid);
  data = sscanf(tline, '%d');
  numEntityBlocks = data(1);
  numElements = data(2);
  minElementTag = data(3);
  maxElementTag = data(4);
  elements = cell(1, numElements); %preallocate memory
  elemId = 0;
  for i = 1:numEntityBlocks
      tline = fgetl(fid);
      data = sscanf(tline, '%d');
      entityDim = data(1);
      entityTag = data(2);
      elementType = data(3):
      numElemsInBlock = data(4);
      for i = 1:numElemsInBlock
        tline = fgetl(fid);
        edata = sscanf(tline '%d', [1, inf]);
        elemId = elemId+1;
        elements{elemId} = [edata(1), elementType, 2, -1, entityTag, edata(2:)' ]);
      end
  end
  mp_read_end_section(fid, '\$EndElements');
  if needclose
    fclose(fid);
  end
end


function [elements] = local_read_elements_ver_2(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Elements');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  elements = cell(1, n); %preallocate memory
  for i = 1:n
    tline = fgetl(fid);
    elements{i} = sscanf(tline,'%d', [1,inf]);
  end
  mp_read_end_section(fid, '\$EndElements');
  if needclose
    fclose(fid);
  end
end
