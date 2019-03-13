classdef ProblemFactory < handle 
  properties (Constant)
    aliases = {'Thermal' {'Thermal', 'T'};
               'Mechanical', {'Mechanical', 'M'};
	             'ThermoMechanical', {'ThermoMechanical', 'TM'};
	            };   
  end
  methods(Static)
    function out = kernel(name)
      persistent kernelName;
      if isempty(kernelName)
        kernelName = 'nadamak';
      end
      if nargin
        kernelName = name;
      end
      out = kernelName;
    end
    function [problem] = produce(alias, options) 
    % Return problem object of a class corresponding to given alias.
    % The object name is taken from problemName argument. If not given the
    % object name is set to 'dummy'.
      if nargin < 2
        options.name = dummy;
      end
      geometry = mp_get_option(options, 'geometry', 'Square');
      nc = size(mp.ProblemFactory.aliases, 1);
      for i=1:nc
        tags = mp.ProblemFactory.aliases(i, 2:end);
	      idx = find(strcmpi(tags{:}, alias));
	      if idx > 0
	        className = [mp.ProblemFactory.aliases{i, 1}, 'Problem'];
          if strcmp(mp.ProblemFactory.kernel(), 'calfem')
            fprintf('Producing problem for calfem\n');  
	        problem = mp.kernel.calfem.(className)(geometry);
          elseif strcmp(mp.ProblemFactory.kernel(), 'nadamak')
            fprintf('Producing problem for nadamak\n')
            problem = mp.kernel.nadamak.(className)(geometry);
          else
            error('Unknown kernel: %s', mp.ProblemFactory.kernel);
          end
	      return
        end
      end
      error('Problem for label "%s" not found', alias);
    end
    function [mainakas] = mainAliases()
    % Return the main aliases for names of Problem classes.
    % The main aliases are used for instance in GUI labels.
      nc = size(mp.ProblemFactory.aliases, 1);
      mainakas = cell(1, nc);
      for i=1:nc
        tags = mp.ProblemFactory.aliases{i, 2:end};
	      mainakas{i} = tags{1};
      end
    end
  end
end

