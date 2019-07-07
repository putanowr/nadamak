classdef BcRegistry < handle
  % Manages association between BoundaryCondition object and the region on which  % it is applied.
  properties (Access=private)
    registry % Structure with fields being registred meshes
                  % This structure works as C++ std::map
  end
  methods
    function [obj] = BcRegistry()
      obj.registry = struct();
    end
    function register(obj, region, bc)
      variableName = bc.variable;
      if ~isfield(obj.registry, region)
         obj.registry.(region) = struct();
      end
      obj.registry.(region).(variableName) = bc;
    end
    function apply(obj, callback)
      for regName = fieldnames(obj.registry)'
        for varName = fieldnames(obj.registry.(regName{:}))'
           bc = obj.registry.(regName{:}).(varName{:});
           callback(regName{:}, bc);
        end
      end
    end
    function exportToProject(obj, project)
      project.data.BC = obj.registry;
      rn = fieldnames(obj.registry);
      for regionName = rn'
        project.data.BC.(regionName{:}) = struct();
        vns = fieldnames(obj.registry.(regionName{:}));
        for vn = vns'
          bc = obj.registry.(regionName{:}).(vn{:});
          bcval.variable = bc.variable;
          bcval.type = char(bc.type);
          bcval.value = bc.value;
          project.data.BC.(regionName{:}) = bcval;
        end
      end
    end
    function writeBc(obj, fid)
      rn = fieldnames(obj.registry);
      for regionName = rn'
        fprintf(fid, 'Region: %s\n', regionName{:});
        vns = fieldnames(obj.registry.(regionName{:}));
        for vn = vns'
          bc = obj.registry.(regionName{:}).(vn{:});
          fprintf('  V: %s  BC: %s\n', bc.variable, char(bc.type));
        end
      end
    end
    function [regNames] = regionNames(obj)
      regNames = fieldnames(obj.registry)';
    end
    function [bchandle] = get(obj, regionName, variableName)
      if isempty(variableName)
        bchandle = obj.registry.(regionName);
      else
        bchandle = obj.registry.(regionName).(variableName);
      end
    end
    function [flag] = hasBc(obj, region, variableName)
      % Return true region has assigned boundary condition.
      % If variableName is empty or not given the it checks
      % for any active BC on region. Otherwise checks for
      % active BC on given region for given variable.
      flag = isfield(obj.registry, region);
      if flag
        vns = fieldnames(obj.registry.(region));
        for vn = vns'
          bc = obj.registry.(region).(vn{:});
          flag = bc.isActive(variableName);
          if flag
            return
          end
        end
      end
    end
  end % methods
end
