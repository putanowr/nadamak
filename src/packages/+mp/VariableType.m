classdef VariableType < int32
  % Numeric tags for variable types.
  enumeration
    State          (1)
    Control        (2)
    Data           (3)
    Derived        (4)
    Auxiliary      (5)
  end
end
