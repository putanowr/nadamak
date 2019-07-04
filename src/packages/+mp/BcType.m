classdef BcType < int32
  % Numeric tags types of boundary conditions.
  enumeration
    NotSet            (0)
    Temperature       (1)
    HeatFlux          (2)
    Insulation        (3)
    Displacement      (10)
    Fixity            (11)
    FixityX           (12)
    FixityY           (13)
    FixityZ           (14)
    FixityXY          (15)
    FixityXZ          (16)
    FixityYZ          (17)
    Pressure          (20)
    Traction          (21)
  end
end
