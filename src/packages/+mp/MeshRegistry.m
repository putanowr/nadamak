classdef MeshRegistry < handle
  % MeshRegistry Manages meshes used in FemModel.
  properties (Access=private)
    meshes=struct() % Structure with fields being registred meshes
                    % This structure works as C++ std::map
  end
  methods
    function [obj] = MeshRegistry()
    end
    function register(obj, mesh, name)
      obj.meshes.(name) = mesh;
    end
    function [mhandle] = get(obj, name)
      mhandle = obj.meshes.(name);
    end
    function [flag] = hasMesh(obj, name)
      % Return true if mesh is already registered under given name.
      flag = isfield(obj.meshes, name);
    end
  end
end
