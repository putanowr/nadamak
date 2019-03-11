classdef BBox < handle
  properties(SetAccess=private)
    extents = []
  end
  methods
    function p = subsref(obj,S)
      switch S(1).type
        case '()'
            p = builtin('subsref', obj.extents, S);
        otherwise    
            p = builtin('subsref', obj, S);   
      end
    end
    function [obj] = BBox(points)
      obj.reset(points);
    end
    function [emin, emax] = getMinMax(obj, points)
       if isa(points, 'mp.SharedArray')
        emin = min(points.Data, [], 1);
        emax = max(points.Data, [], 1);
      else
        emin = min(points, [], 1);
        emax = max(points, [], 1);
       end
    end
    function [center] = getCenter(obj)
      d = obj.dim();
      center = zeros(1,d);
      for i=1:d
        center(i) = 0.5*(obj.extents(2*i)+obj.extents(2*i-1));
      end
    end
    function [d] = dim(obj);
      d = length(obj.extents)/2;
    end
    function [ext]=reset(obj, points)
      [emin, emax] = obj.getMinMax(points);
      ext =[emin;emax];
      obj.extents = ext(:)';
      obj.correct();
      ext=obj.extents;
    end
    function [ext]=update(obj, points)
      if isempty(obj.extents)
        obj.reset(points)
      end
      [emin, emax] = obj.getMinMax(points);
      for i=1:length(emin)
        if obj.extents(2*i-1) > emin(i)
          obj.extents(2*i-1) = emin(i);
        end
        if obj.extents(2*i) < emax(i)
          obj.extents(2*i) = emax(i);
        end
      end
      obj.correct();
      ext = obj.extents;
    end
    function n=numArgumentsFromSubscript(obj,~,~)
      n=1;
    end
    function s=size(obj, varargin)
      if isempty(varargin)
        s = builtin('size', obj.extents);
      else
        s = builtin('size', obj.extents, varargin{1});
      end
    end
    function n = numel(obj,~)
      n = builtin('numel', obj.extents);
    end
    function n = length(obj)
      n = builtin('length', obj.extents);
    end
  end
  methods(Access=private)
    function obj=subsasgn(obj, S, V)
      switch S(1).type
        case '()'
          obj.extents = builtin('subsasgn', obj.extents, S, V);
        otherwise
          obj = builtin('subsasgn', obj, S, V);
      end
    end
    function [dummy]=correct(obj)
      dummy = [];
      for i=1:3
        if abs(obj.extents(2*i-1)-obj.extents(2*i)) < 1.e-8
          obj.extents(2*i-1) = -Inf;
          obj.extents(2*i) = Inf;
        end
      end
    end
  end
end

