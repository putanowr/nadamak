function [tag] = bc2tag(bc, ambientDim)
  if ambientDim == 2
    tag = bc2tag_2D(bc);
  elseif ambientDim == 3
    tag = bc2tag_3D(bc);
  else
    error('Invalid ambient dimension : %d', ambientDim);
  end
end
function [tag] = bc2tag_3D(bc)
  % Convet BoundaryCondition to enum to FlagSHyp numeric tag
  % 
  persistent b2t
  if isempty(b2t)
    b2t = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    b2t(int32(mp.BcType.NotSet))   = 0;
    b2t(int32(mp.BcType.FixityX))  = 1;
    b2t(int32(mp.BcType.FixityY))  = 2;
    b2t(int32(mp.BcType.FixityXY)) = 3;
    b2t(int32(mp.BcType.FixityZ))  = 4;
    b2t(int32(mp.BcType.FixityXZ)) = 5;
    b2t(int32(mp.BcType.FixityYZ)) = 6;
    b2t(int32(mp.BcType.Fixity))   = 7;
  end 
  if ~b2t.isKey(int32(bc.type))
    if bc.type == mp.BcType.Displacement
      v = bc.value;
      if numel(v) < 3
        v(3) = 0;
      end
      mv = ismissing(v);
      if isequal(mv, [false, true, true])
        tag = b2t(int32(mp.BcType.FixityX));
      elseif isequal(mv, [true, false, true])
        tag = b2t(int32(mp.BcType.FixityY));
      elseif isequal(mv,[true, true, false])
        tag = b2t(int32(mp.BcType.FixityZ));
      elseif isequal(mv,[false, false, true])
        tag = b2t(int32(mp.BcType.FixityXY));
      elseif isequal(mv,[false, true, false])
        tag = b2t(int32(mp.BcType.FixityXZ));
      elseif isequal(mv, [true, false, false])
        tag = b2t(int32(mp.BcType.FixityYZ));
      elseif isequal(mv, [false, false, false])
        tag = b2t(int32(mp.BcType.Fixity));
      elseif isequal(mv,[true, true, true])
        tag = 0;
      end  
    else
      tag = 0;
    end  
  else 
    tag = b2t(int32(bc.type));
  end  
end
function [tag] = bc2tag_2D(bc)
  % Convet BoundaryCondition to enum to FlagSHyp numeric tag
  % 
  persistent b2t
  if isempty(b2t)
    b2t = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    b2t(int32(mp.BcType.NotSet))   = 0;
    b2t(int32(mp.BcType.FixityX))  = 1;
    b2t(int32(mp.BcType.FixityY))  = 2;
    b2t(int32(mp.BcType.FixityXY)) = 3;
    b2t(int32(mp.BcType.FixityZ))  = 0;
    b2t(int32(mp.BcType.FixityXZ)) = 1;
    b2t(int32(mp.BcType.FixityYZ)) = 2;
    b2t(int32(mp.BcType.Fixity))   = 3;
  end 
  if ~b2t.isKey(int32(bc.type))
    if bc.type == mp.BcType.Displacement
      v = bc.value(1:2);
      mv = ismissing(v);
      if isequal(mv, [false, true])
        tag = b2t(int32(mp.BcType.FixityX));
      elseif isequal(mv, [true, false])
        tag = b2t(int32(mp.BcType.FixityY));
      elseif isequal(mv,[false, false])
        tag = b2t(int32(mp.BcType.FixityXY));
      elseif isequal(mv,[true, true])
        tag = 0;
      end  
    else
      tag = 0;
    end  
  else 
    tag = b2t(int32(bc.type));
  end  
end
