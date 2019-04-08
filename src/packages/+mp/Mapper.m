classdef Mapper < handle
  properties(SetAccess=protected)
    F
    domainDim
    targetDim
  end
  methods
    function obj = Mapper(f)
      if nargin < 1
        sysm x y z
        obj.setMap(symfun([x,y,z], [x,y,z]));
      else
        obj.setMap(f)
      end
    end
    function setMap(obj, symFun)
      obj.domainDim = numel(symvar(symFun));
      obj.targetDim = numel(formula(symFun));
      obj.F = symFun;
    end
    function mapMesh(obj, mesh)
      switch obj.domainDim
        case 1
          val = obj.F(mesh.nodes(:,1));
        case 2
          val = obj.F(mesh.nodes(:,1),mesh.nodes(:,2));
        case 3
          val = obj.F(mesh.nodes(:,1),mesh.nodes(:,2),mehs.nodes(:,3));
        otherwise
          error('Mapper with more than 3 independent variables')
      end
      if iscell(val)
        val = double([val{1:obj.targetDim}]);
      else
        val = double(val);
      end
      mesh.nodes(:,1:obj.targetDim) = val;
    end
    function v = vars(obj)
      v = symvar(obj.F);
    end
    function val = at(obj, pt)
      farg = zeros(size(pt,1), obj.domainDim);
      nz = min(obj.domainDim, size(pt,2));
      farg(:,1:nz) = pt(:,1:nz);
      switch obj.domainDim
        case 1
          val = obj.F(farg(:,1));
        case 2
          val = obj.F(farg(:,1),farg(:,2));
        case 3
          val = obj.F(farg(:,1),farg(:,2),farg(:,3));
        otherwise
          error('Mapper with more than 3 independent variables')
      end
      if iscell(val)
        val = double([val{1:obj.targetDim}]);
      else
        val = double(val);
      end
    end
    function status = isCurve(obj)
      status = (obj.domainDim == 1);
    end
    function status = isSurface(obj)
      status = (obj.domainDim == 2);
    end
    function compound = horzcat(map1, map2, varargin)
      compound = mp.Mapper();
      f = formula(map1.F);
      fn = subs(f, map1.vars, formula(map2.F));
      compound.setMap(symfun(fn, map2.vars));
    end
    function L = arcLength(obj, a,b)
      if ~obj.isCurve()
        error('Mapper is not a curve');
      end
      pt1 = zeros(1, obj.domainDim);
      pt1(1) = a;
      pt2 = zeros(1, obj.domainDim);
      pt2(1) = b;
      t = symvar(obj.F, 1);
      df = diff(obj.F, t);
      vt = simplify(sqrt(sum(df.^2)));
      L = vpaintegral(vt, t, pt1, pt2);
    end
    function S = area(obj, a,b,c,d)
      if ~obj.isSurface()
        error('Mapper is not a surface');
      end
      st = symvar(obj.F);
      drs = diff(obj.F, st(1))
      drt = diff(obj.F, st(2))
      Ef = drs*drs';
      Ff = drs*drt';
      Gf = drt*drt';
      f = simplify(sqrt(Ef*Gf - Ff^2));
      S = vpaintegral(vpaintegral(f,st(1),[a,b]),st(2),c,d);
    end
  end
end

