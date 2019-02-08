classdef Variable
  % Stores data to describe a variable in problem formulation
  properties(SetAccess=private)
    size
    rank
    numOfComponents
    name
    type 
  end
  methods
    function [obj] = Variable(name, size, type)
      if length(size) == 1 && size(1) == 1
        obj.rank = 0;
      else
        obj.rank = length(size)
      end
      obj.numOfComponents = prod(size);
      obj.size = size;
      obj.type = type;
      obj.name = name;
    end
    function qst = isState(obj)
      qst = (obj.type == mp.VariableType.State)
    end
    function qst = isControl(obj)
      qst = (obj.type == mp.VariableType.Control)
    end
    function qst = isDerived(obj)
      qst = (obj.type == mp.VairableType.Derived)
    end
  end
end
