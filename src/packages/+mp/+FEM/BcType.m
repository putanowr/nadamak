classdef BcType < int32
  % Numeric tags types of boundary conditions.
  enumeration
    Temperature       (1)
    HeatFlux          (2)
    Insulation        (3)
    Displacement      (10)
    Fixity            (11)
    XFixity           (12)
    YFixity           (13)
    ZFixity           (14)
    Pressure          (20)
    Traction          (21)
  end
end