classdef BcFactory < handle 
  properties (Constant)
    aliases = {'Displacement', {'Displacement', 'U'};
               'Temperature' {'Temperature', 'T', 'Temp', 'Theta'};
              };              
  end
  methods(Static)
    function [bc] = produce(bcname, varname, params)
      if nargin < 3
        params = struct()
      end
      bcname = sprintf('%s', bcname);
      [vbc, trueVarName] = mp.BcFactory.validBc(varname);
      idx = find( vbc == bcname);
      if idx > 0
        bcclass = sprintf('Bc%s', bcname);
        bc = mp.(bcclass)(trueVarName, params);
      else
        error('Bc of type %s is not valid for variable %s', bcname, varname);
      end
    end
    function [validbc, trueVarName] = validBc(varname)
      helpers = {@mp.BcFactory.validBcForDisplacement;
                 @mp.BcFactory.validBcForTemperature};
      % Return vector of BC applicable to this variable type
      nc = size(mp.BcFactory.aliases, 1);
      for i=1:nc
        tags = mp.BcFactory.aliases(i, 2:end);
	      idx = find(strcmpi(tags{:}, varname));
	      if idx > 0
	        validbc = helpers{i}();
          trueVarName = mp.BcFactory.aliases{i,1};
          return
        end
      end
      error('Variable "%s" has not valid BCs', varname);
    end
    function [validbc] = validBcForDisplacement()
      validbc = [mp.BcType.NotSet, mp.BcType.Displacement, mp.BcType.Fixity,...
                 mp.BcType.FixityX, mp.BcType.FixityY mp.BcType.FixityZ,...
                 mp.BcType.FixityXY, mp.BcType.FixityXZ, mp.BcType.FixityYZ,...
                 mp.BcType.Pressure, mp.BcType.Traction];
    end
    function [validbc] = validBcForTemperature()
      validbc = [mp.BcType.NotSet, mp.BcType.HeatFlux, mp.BcType.Insulation];
    end
  end
end
