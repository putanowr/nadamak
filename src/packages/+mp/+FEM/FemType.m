classdef FemType 
  % Types of Finite Elements.
  enumeration
    % items: gmsh_elem_type, isLagrangian, order, num_of_dofs, 
    % localCoordsCalback, dofTopoCallback
    Line2( 1,true,1,1, 2, @mp.FEM.localCoordsLine2, @mp.FEM.dofTopoLine2, @mp.FEM.sfLine2)
    Triang3(  2,true,2,1, 3, @mp.FEM.localCoordsTriang3,  @mp.FEM.dofTopoTriang3, @mp.FEM.sfTriang3)
    Triang6(  9,true,2,2, 6, @mp.FEM.localCoordsTriang6,  @mp.FEM.dofTopoTriang6, @mp.FEM.sfTriang6)
    Triang10(21,true,2,3,10, @mp.FEM.localCoordsTriang10, @mp.FEM.dofTopoTriang10, @mp.FEM.sfTriang10)
    Quad4( 3,true,2,1, 4, @mp.FEM.localCoordsQuad4, @mp.FEM.dofTopoQuad4, @mp.FEM.sfQuad4)
  end
  methods
    function [self]=FemType(gmshID, isLagrangian, dim, order, numOfDofs, cfh, tfh, sfh)
      self.dim = dim;
      self.gmshID = gmshID;
      self.isLagrangian = isLagrangian;
      self.order = order;
      self.numOfDofs = numOfDofs;
      self.cfh = cfh; 
      self.tfh = tfh;
      self.sfh = sfh;
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
    dim
    gmshID
    isLagrangian
    order
    numOfDofs
    cfh
    tfh
    sfh
  end
end
