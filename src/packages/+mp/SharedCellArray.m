classdef SharedCellArray < handle
  %SHAREDARRAY cell array that is accessed by a handle.
  properties(SetAccess=private)
    Data 
  end
  methods
    function [obj] = SharedCellArray(n)
      obj.Data = cell(1, n);
    end
    function p = subsref(obj,S)
      switch S(1).type
        case '{}'
          p = builtin('subsref', obj.Data, S);
        case '()'
          p = builtin('subsref', obj.Data, S);
        otherwise
          p = builtin('subsref', obj, S);
      end
    end
    function obj=subsasgn(obj, S, V)
      switch S(1).type
        case '()'
          obj.Data = builtin('subsasgn', obj.Data, S, V);
        case '{}'
          obj.Data = builtin('subsasgn', obj.Data, S, V);
        otherwise
          obj = builtin('subsasgn', obj, S, V);
      end
    end
    function n=numArgumentsFromSubscript(obj,~,~)
      n=1;
    end
    function s=size(obj, varargin)
      if isempty(varargin)
        s = builtin('size', obj.Data);
      else
        s = builtin('size', obj.Data, varargin{1});
      end
    end
    function n = numel(obj,~)
      n = builtin('numel', obj.Data);
    end
    function n = length(obj)
      n = builtin('length', obj.Data);
    end
  end 
end

