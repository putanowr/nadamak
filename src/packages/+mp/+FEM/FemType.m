classdef FemType
  % Types of Finite Elements.
  enumeration
    % items: gmsh_elem_type, isLagrangian, order, num_of_dofs,
    % localCoordsCalback, dofTopoCallback
    Line2(    1,true,1,1, 2, 'Line2')
    Triang3(2,true,2,1, 3, 'Triang3')
    Triang6(9,true,2,2, 6, 'Triang6')
    Triang10(21,true,2,3,10, 'Triang10')
    Quad4( 3,true,2,1, 4, 'Quad4')
  end
  methods
    function [self]=FemType(gmshID, isLagrangian, dim, order, numOfDofs, name)
      self.dim = dim;
      self.gmshID = gmshID;
      self.isLagrangian = isLagrangian;
      self.order = order;
      self.numOfDofs = numOfDofs;
      self.cfh = str2func(sprintf('mp.FEM.localCoords%s', name));
      self.tfh = str2func(sprintf('mp.FEM.dofTopo%s', name));
      self.sfh = str2func(sprintf('mp.FEM.sf%s', name));
      self.sfDh = str2func(sprintf('mp.FEM.sfDeriv%s', name));
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
  methods (Static)
    function [type] = fromId(id)
       persistent id2type
       if isempty(id2type)
	  id2type = containers.Map('KeyType', 'int32', ...
	                           'ValueType', 'char');
          for t = enumeration('mp.FEM.FemType')'
             id2type(t.gmshID) = sprintf('%s',t);
          end
       end
       type = mp.FEM.FemType(id2type(id));
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
    sfDh
  end
end
