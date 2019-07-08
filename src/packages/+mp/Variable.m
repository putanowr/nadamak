classdef Variable
  % Stores data to describe a variable in problem formulation
  properties(SetAccess=private)
    qdim
    rank
    numOfComponents
    name
    type
  end
  methods
    function [obj] = Variable(name, qdim, type)
      if length(qdim) == 1 && qdim(1) == 1
        obj.rank = 0;
      else
        obj.rank = length(qdim);
      end
      obj.numOfComponents = prod(qdim);
      obj.qdim = qdim;
      obj.type = type;
      obj.name = name;
    end
    function qst = isState(obj)
      qst = (obj.type == mp.VariableType.State);
    end
    function qst = isControl(obj)
      qst = (obj.type == mp.VariableType.Control);
    end
    function qst = isDerived(obj)
      qst = (obj.type == mp.VairableType.Derived);
    end
    function qst = isData(obj)
      qst = (obj.type == mp.VariableType.Data);
    end
  end
end
