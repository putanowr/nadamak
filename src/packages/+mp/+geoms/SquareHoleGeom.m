classdef SquareHoleGeom < mp.GeomModel 
  % Geometric model for Square with circular hole.
  properties (Access=public)
    params = struct('dW', 3.0, 'dr', 0.8, 'lcFactors', [1,1,1,1,1,1,1,1]);
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.dW = mp_get_option(params_, 'dW', obj.params.dW);
      obj.params.dr = mp_get_option(params_, 'dr', obj.params.dr);
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors', obj.params.lcFactors);
      obj.fix_lc_factors();
    end
  end  
  methods
    function [obj] = SquareHoleGeom(name, params_, legacyID)
      if nargin < 3
        legacyID = 0;
      end
      if nargin < 2
	params_ = struct();
      end
      obj = obj@mp.GeomModel(name, 2, 2, legacyID);
      if ~isempty(params_)
	obj.setup(params_);
      end	
    end
    function [regionNames] = regions(~)
      regionNames = {'d_domain', 'b_outer_s', 'b_outer_e', 'b_outer_n', ...
                     'b_outer_w', 'b_inner'};
    end
    function [name] = templateName(~)
      % templateName : return name of the template file to generate GMSH model.
      name = 'circ_hole.tpl';
    end
    function [geomgmsh] = as_gmsh(obj)
      % as_gmsh : return string containg GMSH model description
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      obj.fix_lc_factors();
      geomgmsh = mp_tpl_substitute(tpl, obj.params);
    end
    function [maxlc] = coarsest_lc(obj)
      % coarsest_lc : return sensible upper limit on edge length.
      %
      % This value can be used to set up coarsets mesh.
      maxlc = obj.params.dW;
    end
  end
  methods(Access=private)
    function fix_lc_factors(obj)
      ln = length(obj.params.lcFactors);
      if ln < 8
        obj.params.lcFactors = [obj.params.lcFactors, ones(1, 8-ln)];
      end	
    end
  end
end
