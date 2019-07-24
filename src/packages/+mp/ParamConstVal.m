classdef ParamConstVal < mp.ParamValueBase
  properties (Access = private)
    cv
  end
  methods
    function obj=ParamConstVal(initval)
      obj = obj@mp.ParamValueBase();
      obj.cv = initval;
    end
    function val = getValue(obj, ~)
      val = obj.cv;
    end
    function td = dataTable(obj)
      td = [nan, obj.cv];
    end  
  end
end  
