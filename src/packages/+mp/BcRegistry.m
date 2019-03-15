classdef BcRegistry < handle
  % Manages association between BoundaryCondition object and the region on which  % it is applied.
  properties (Access=private)
    registry % Structure with fields being registred meshes
                  % This structure works as C++ std::map
  end
  methods
    function [obj] = MeshRegistry()
      obj.registry = struct();
    end
    function register(obj, region, bc)
      obj.registry.(region) = bc;
    end
    function [bchandle] = get(obj, region)
      bchandle = obj.registry.(name);
    end
    function [flag] = hasBc(obj, region)
      % Return true region has assigned boundary condition.
      flag = isfield(obj.registry, region);
      if flag
        for bc = obj.registry.(region)
          if bc.type ~= mp.BcType.NotSet
            flag = true;
            return
          end
        end
        flag = false;
      end
    end
  end
end
