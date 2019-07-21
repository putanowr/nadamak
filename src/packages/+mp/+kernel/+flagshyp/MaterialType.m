classdef MaterialType
  % Types of material models supported by FlagSHyp kernel.
  enumeration
    % items: gmsh_elem_type, isLagrangian, dimension, order, num_of_dofs,
    % localCoordsCalback, dofTopoCallback
    MT1(    1)
    MT2(    2)
    MT3(    3)
    MT4(    4)
    MT5(    5)
    MT6(    6)
    MT7(    7)
    MT8(    8)
    MT17(  17)
  end
  methods
    function [self]=MaterialType(id)
      self.id = id;
      name = sprintf('MT%d', id);
      info = mp.kernel.flagshyp.MaterialType.modelsInfo();
      item = info.(name);
      self.description = item.description;
      self.params = item.params;
    end
  end
  methods (Static)
    function listModels(fid)
      if nargin < 1
        fid = 1;
      end
      for t = enumeration('mp.kernel.flagshyp.MaterialType')'
        fprintf(fid, '%s : %s\n', char(t), t.description);
      end
    end  
    function [info] = modelsInfo()
      persistent setupstruct
      if isempty(setupstruct)
        fname = fullfile(fileparts(mfilename('fullpath')),...
                'flagshyp_material_models.json')
        try
          s = fileread(fname);
          setupstruct = jsondecode(s);
        catch
          error('Cannot read file %s\nMake sure file exists and is proper',...
                fname);
        end  
      end
      info = setupstruct;
    end
    function [type] = fromId(id)
       persistent id2type
       if isempty(id2type)
	        id2type = containers.Map('KeyType', 'int32', ...
	                                 'ValueType', 'char');
          for t = enumeration('mp.kernel.flagshyp.MaterialType')'
             id2type(t.id) = sprintf('%s',t);
          end
       end
       try
         type = mp.kernel.flagshyp.MaterialType(id2type(id));
       catch
         error('Material type not supported id: %d', id);
       end  
    end
  end
  properties(SetAccess=immutable)
    id 
    description 
    params
  end
end
