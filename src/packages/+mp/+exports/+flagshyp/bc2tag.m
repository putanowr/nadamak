function [tag] = bc2tag(bctype)
  % Convet mp.BcType enum to FlagSHyp numeric tag
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
  if ~b2t.isKey(int32(bctype))
    error('Boundary condition of type %s not supported in FlagSHyp', char(bctype));
  end
  tag = b2t(int32(bctype));
end
