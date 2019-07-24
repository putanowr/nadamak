classdef ParametricModel 
  properties (Constant)
    Data = mp.ModelSharedData 
  end
  methods
    function t=time(obj)
      t = obj.Data.gtime;
    end
  end
end
