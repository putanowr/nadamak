classdef ImType 
  % Types of integration methods.
  enumeration
    % items: gmsh_elem_type of reference element, dimension, order
    Gauss1D_1(1,1,1)
    Gauss1D_3(1,1,3)
    Gauss1D_5(1,1,5)
    Gauss1D_7(1,1,7)
    Gauss1D_9(1,1,9)
    Gauss1D_11(1,1,11)
    Triangle_1(2,2,1)
    Triangle_2(2,2,2)
    Triangle_3(2,2,3)
    Triangle_4(2,2,4)
  end
  methods
    function [self]=ImType(gmshID, dim, order)
      self.dim = dim;
      self.gmshID = gmshID;
      self.order = order;
    end
  end 
  properties(SetAccess=immutable)
    dim
    gmshID
    order
  end
end
