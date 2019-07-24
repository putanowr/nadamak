classdef ParametricModel
  properties (Constant)
    Data = mp.ModelSharedData
  end
  methods
    function t=time(obj, newTime)
      if nargin > 1
        obj.Data.gtime = newTime;
      end
      t = obj.Data.gtime;
    end
  end
end
