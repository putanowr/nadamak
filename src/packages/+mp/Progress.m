classdef Progress < handle
  % Prgress base class for reporting progress.
  properties(SetAccess=private)
    callbacks = struct();
    fraction double;
  end
  methods
    function [obj] = Progress()
    end
    function report(obj, fraction, message)
      obj.fraction = fraction;
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
      rmfield(obj.callbacks, name);
    end
  end
end
