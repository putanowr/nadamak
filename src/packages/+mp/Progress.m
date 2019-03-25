classdef Progress < handle
  % Prgress base class for reporting progress.
  properties(SetAccess=protected)
    callbacks = struct();
    fraction double;
  end
  methods
    function [obj] = Progress()
      obj.fraction = 0.0;
    end
    function report(obj, fraction, message)
      if ~isempty(fraction)
        obj.fraction = fraction;
      end
      fn = fieldnames(obj.callbacks);
      for f = fn'
          h = obj.callbacks.(f{:});
          h(message);
      end
    end
    function addCallback(obj, name, handle)
      obj.callbacks.(name) = handle;
    end
    function removeCallback(obj, name)
      obj.callbacks = rmfield(obj.callbacks, name);
    end
  end
end
