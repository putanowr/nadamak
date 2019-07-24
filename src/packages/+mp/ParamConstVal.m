classdef ParamConstVal < mp.ParamValueBase
  properties (SetAccess = immutable)
    cv
  end
  methods
    function obj=ParamConstVal(initval)
      obj = obj@mp.ParamValueBase(mp.ParamType.Const);
      obj.cv = initval;
    end
    function val = valueAt(obj, ~)
      val = obj.cv;
    end
    function td = dataTable(obj)
      td = [nan, obj.cv];
    end
  end
end  
