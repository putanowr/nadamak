classdef Mapper < handle
  properties(SetAccess=protected)
    F
    domainDim
    ambientDim
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
      obj.ambientDim = numel(formula(symFun));
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
        val = double([val{1:obj.ambientDim}]);
      else
        val = double(val);
      end
      mesh.nodes(:,1:obj.ambientDim) = val;
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
        val = double([val{1:obj.ambientDim}]);
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
    function status = isVolume(obj)
      status = (obj.domainDim == 3);
    end
    function status = isTransitionMap(obj)
      % Return true if the dimension of domain and codomain are the same.
      status = (obj.domainDim == obj.ambientDim);
    end
    function compound = horzcat(map1, map2, varargin)
      compound = mp.Mapper();
      f = formula(map1.F);
      fn = subs(f, map1.vars, formula(map2.F));
      compound.setMap(symfun(fn, map2.vars));
    end
    function L = arcLength(obj,a,b)
      if ~obj.isCurve()
        error('Mapper is not a curve');
      end
      if nargin < 3
        if numel(a) ~= 2
          error('Expecting second argument to be 2 element vector');
        end
        b = a(2);
        a = a(1);
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
    function S = area(obj, sa,sb,ta,tb)
      if ~obj.isSurface()
        error('Mapper is not a surface');
      end
      if nargin ~= 5 && nargin ~=3
        error('Invalid number of arguments')
      end
      if nargin == 3
        ta = sb(1);
        tb = sb(2);
        sb = sa(2);
        sa = sa(1);
      end
      st = symvar(obj.F);
      drs = diff(obj.F, st(1));
      drt = diff(obj.F, st(2));
      Ef = drs*drs';
      Ff = drs*drt';
      Gf = drt*drt';
      f = simplify(sqrt(Ef*Gf - Ff^2));
      S = vpaintegral(vpaintegral(f,st(1),[sa,sb]),st(2),ta,tb);
    end
    function S = volume(obj, sa,sb,ta,tb,ua,ub)
      if ~obj.isVolume()
        error('Mapper is not a volume');
      end
      if nargin ~= 7 && nargin ~= 4
        error('Invalid number of arguments')
      end
      if nargin == 4
        ua = ta(1)
        ub = ta(2);
        ta = sb(1);
        tb = sb(2);
        sb = sa(2);
        sa = sa(1);
      end
      st = symvar(obj.F);
      drs = diff(obj.F, st(1));
      drt = diff(obj.F, st(2));
      dru = diff(obj.F, st(3));
      f = simplify(det([drs;drt;dru]));
      S = vpaintegral(vpaintegral(vpaintegral(f,st(1),[sa,sb]),st(2),ta,tb), st(3), ua,ub);
    end
  end
end

