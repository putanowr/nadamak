classdef GeomFactory < handle 
  properties (Constant)
    aliases = {'Rectangle', {'Rectangle', 'RectangleGeom'};
               'Square',    {'Square',    'SquareGeom'};
	             'LShape',    {'L-Shape',   'LShapeGeom', 'LShape', 'L'};
	            };   
  end
  methods(Static)
    function [geom] = produce(alias, geomName) 
    % Return geometry object of a class corresponding to given alias.
    % The object name is taken from geomName argument. If not given the
    % object name is set to 'dummy'.
      if nargin < 2
        geomName = 'dummy';
      end
      nc = size(mp.GeomFactory.aliases, 1);
      for i=1:nc
        tags = mp.GeomFactory.aliases(i, 2:end);
	      idx = find(strcmpi(tags{:}, alias));
	      if idx > 0
	        className = [mp.GeomFactory.aliases{i, 1}, 'Geom'];
	        geom = mp.geoms.(className)(geomName);
	        return
        end
      end
      error('Geometry for label "%s" not found', alias);
    end
    function [mainakas] = mainAliases()
    % Return the main aliases for names of Geom classes.
    % The main aliases are used for instance in GUI labels.
      nc = size(mp.GeomFactory.aliases, 1);
      mainakas = cell(1, nc);
      for i=1:nc
        tags = mp.GeomFactory.aliases{i, 2:end};
	      mainakas{i} = tags{1};
      end
    end
  end
end

