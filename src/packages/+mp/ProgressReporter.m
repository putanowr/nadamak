classdef ProgressReporter < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    barWidget % wait bar widget
  end
  methods
    function [obj] = ProgressReporter(type_)
    end
    function report(obj, message, fraction)
      if ~isempty(obj.barWidget)
        waitbar(fraction, obj.barWidget, message);
      end
    end
    function setBar(obj, barHandle)
      obj.barWidget = barHandle;
    end
    function closeBar(obj)
      if ~isempty(obj.barWidget)
        close(obj.barWidget);
        obj.barWidget = [];
      end
    end
  end
end
