classdef ProgressGUI < mp.Progress
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    barWidget % wait bar widget
  end
  methods
    function [obj] = ProgressGUI()
    end
    function report(obj, fraction, message)
      report@mp.Progress(obj, fraction, message);
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
