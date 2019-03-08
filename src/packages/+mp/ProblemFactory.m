classdef ProblemFactory < handle 
  properties (Constant)
    aliases = {'Thermal' {'Thermal', 'T'};
               'Mechanical', {'Mechanical', 'M'};
	             'ThermoMechanical', {'ThermoMechanical', 'TM'};
	            };   
  end
  methods(Static)
    function [problem] = produce(alias, problemName) 
    % Return problem object of a class corresponding to given alias.
    % The object name is taken from problemName argument. If not given the
    % object name is set to 'dummy'.
      nc = size(mp.ProblemFactory.aliases, 1);
      for i=1:nc
        tags = mp.ProblemFactory.aliases(i, 2:end);
	      idx = find(strcmpi(tags{:}, alias));
	      if idx > 0
	        className = [mp.ProblemFactory.aliases{i, 1}, 'Problem']
	        problem = mp.(className)();
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

