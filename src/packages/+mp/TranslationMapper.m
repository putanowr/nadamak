classdef TranslationMapper < mp.Mapper
  methods
    function obj = TranslationMapper(V)
      n = numel(V);
      syms x y z
      switch n
        case 1
          obj.F = symfun([x], x);
        case 2
          obj.F = symfun([x+V(1), y+V(2)], [x,y]);
        case 3
          obj.F = symfun([x+V(1), y+V(2), z+V(3)], [x,y,z]);
        otherwise
          error('Translation mapp for dim > 3 not supported');
      end
    end    
    function V = Vector(obj)
      pt = [0,0,0];
      newPt = obj.at(pt);
      V = newPt - pt;
    end
  end  
end

