classdef Material < dynamicprops
  properties (SetAccess=immutable)
    name
    type
  end
  methods
    function obj=Material(name, materialType)
      obj=obj@dynamicprops();
      obj.type = materialType;
      obj.name = name;
      for param = materialType.params'
        obj.addprop(param{:});
        obj.(param{:}) = nan;
      end
    end
  end
end
