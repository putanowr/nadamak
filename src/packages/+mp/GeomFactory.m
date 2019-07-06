classdef GeomFactory < handle
  properties (Constant)
    akas = {'Rectangle', {'Rectangle', 'RectangleGeom'};
            'RectangleIface', {'Rectangle with interface', 'RectangleIfaceGeom' 'RectangleIface'};
            'Square',    {'Square',    'SquareGeom'};
	          'LShape',    {'L-Shape',   'LShapeGeom', 'LShape', 'L'};
            'Cube',      {'Cube',      'CubeGeom'};
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
      akas = mp.GeomFactory.aliases(alias);
      className = akas{2};
      geom = mp.geoms.(className)(geomName);
    end
    function [tags] = aliases(name)
      nc = size(mp.GeomFactory.akas, 1);
      for i=1:nc
        tags = mp.GeomFactory.akas{i, 2:end};
	      idx = find(strcmpi(tags, name));
	      if idx > 0
	        return
        end
      end
      error('Aliases for geometry label "%s" not found', name);
    end
    function [pname] = projectName(name)
      akas = mp.GeomFactory.aliases(name);
      pname = akas{1};
    end
    function [mainakas] = mainAliases()
    % Return the main aliases for names of Geom classes.
    % The main aliases are used for instance in GUI labels.
      nc = size(mp.GeomFactory.akas, 1);
      mainakas = cell(1, nc);
      for i=1:nc
        tags = mp.GeomFactory.akas{i, 2:end};
	      mainakas{i} = tags{1};
      end
    end
  end
end

