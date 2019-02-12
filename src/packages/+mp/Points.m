classdef Points < handle
  % Points Manage set of points in 3D.
  %  
  properties (Access=private)
    coords_ = [];
    ids_ = []; 
  end
  methods
    function [obj] = Points(coords, ids)
      % Points constructor.
      if nargin > 0
        obj.coords_ = coords;
        if nargin > 1
          obj.ids_ = ids;
          if length(ids) ~= size(coords, 1)
            error('Incompatible size of coords  %d ids %d', ...
                size(coords, 1), length(ids));
          end        
        end
      end  
    end
    function [val] = length(self)
      %% Return number of points
      val = size(self.coords_,1);
    end
    function [val] = ids(self)
      if isempty(self.ids_)
        val = 1:size(self.coords_,1);
      else
        val = self.ids_;
      end
    end
    function [val] = dim(self)
      %% Return number of coordinates per point
      val = size(self.coords_,2);
    end
    function [val] = minId(self)
      %% Return minimal Id number
      val = 1;
      if ~isempty(self.ids_)
         val = min(self.ids_);
      end
    end
    function [val] = maxId(self)
      %% Return maximal Id number
      if isempty(self.ids_)
        val = size(self.coords_, 1);
      else
        val = max(self.ids_);
      end
    end
    function [val] = areIdsContinuous(self)
      %% Return true if ids form a 1:n range
      val = (self.maxId() == length(self.coords_));
    end
    function [xyz] = at(self, id)
      %% Return point with given id.
      if isempty(self.ids_)
        xyz = self.atContinuous(id);
      else
        xyz = self.atDiscontinuous(id);
      end
    end
  end % end public methods
    
  methods (Access=private)
    function [xyz]=atDiscontinuous(self, id)
      k = find(self.ids_ == id);
      if isempty(k)
        error('Non existing id : %d', id');
      end  
      if length(k) > 1
        error('Corrupted ids : not unique. Duplicated entries %d', k);
      end
      xyz = self.coords_(k,:);
    end
    function [xyz]=atContinuous(self, id)
      xyz = self.coords_(id,:);
    end
    function allocate(self, n)
      self.coords_ = zeros(n, 3);
    end
  end
end