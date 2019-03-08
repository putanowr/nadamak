classdef ProgressReporter < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    barWidget % wait bar widget
    callbacks = struct();
  end
  methods
    function [obj] = ProgressReporter()
    end
    function report(obj, fraction, message)
      if ~isempty(obj.barWidget)
        waitbar(fraction, obj.barWidget, message);
      end
      fn = fieldnames(obj.callbacks);
      for f = fn'
          h = obj.callbacks.(f{:});
          h(message);
      end
    end
    function setBar(obj, barHandle)
      obj.barWidget = barHandle;
    end
    function addCallback(obj, name, handle)
      obj.callbacks.(name) = handle;
    end
    function closeBar(obj)
      if ~isempty(obj.barWidget)
        close(obj.barWidget);
        obj.barWidget = [];
      end
    end
  end
end
