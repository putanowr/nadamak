classdef FemType 
  % Types of Finite Elements.
  enumeration
    Line2(1,true,1,2, @mp.FEM.localCoordsLine2, @mp.FEM.dofTopoLine2)
    Tri3(2,true,1,3, @mp.FEM.localCoordsTri3, @mp.FEM.dofTopoTri3)
    Tri6(9,true,2,6, @mp.FEM.localCoordsTri6, @mp.FEM.dofTopoTri6)
    Quad4(3,true,1,4, @mp.FEM.localCoordsQuad4, @mp.FEM.dofTopoQuad4)
  end
  methods
    function [self]=FemType(gmshID, isLagrangian, order, numOfDofs, cfh, tfh)
      self.gmshID = gmshID;
      self.isLagrangian = isLagrangian;
      self.order = order;
      self.numOfDofs = numOfDofs;
      self.cfh = cfh; 
      self.tfh = tfh; 
    end
    function [info]=getInfo(self)
      info = mp_gmsh_types_info(self.gmshID);
    end
    function [nnodes]=nodesCount(self)
      info = mp_gmsh_types_info(self.gmshID);
      nnodes = info.nnodes;
    end
    function [xyz]=pointOfDof(obj, dofID)
      f = obj.cfh;
      xyz=f(dofID);
    end
    function [xyz]=dofsCoords(obj)
      f = obj.cfh;
      xyz = f();
    end
    function [t] = topoOfDof(obj, dofID)
      f = obj.tfh;
      t = f(dofID);
    end
    function [t] = dofsTopo(obj)
      f = obj.tfh;
      t = f();
    end
  end 
  properties(SetAccess=immutable)
    gmshID
    isLagrangian
    order
    numOfDofs
    cfh
    tfh
  end
end
