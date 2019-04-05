classdef GeomTrans < handle
  %GeomTrans - performs geometric transformation from reference to real element.
  properties (SetAccess=private)
    mesh
    fem
    cellToNodes
    dim
  end
  methods
    function [obj] = GeomTrans(mesh, targetDim)
      if nargin < 2
        obj.dim = mesh.dim;
      else
        obj.dim = targetDim;
      end
      if (obj.dim > mesh.dim || obj.dim < 1)
        error('Invalid GeomTrans dimension %d, expected value in range [1, %d]', obj.dim, mesh.dim)
      end
      obj.mesh = mesh;
      obj.cellToNodes = mesh.getAdjacency(obj.dim, 0);
      ct = mesh.cellTypes(obj.dim);
      if (length(ct) > 1)
        %error('GeomTrans not cannot handle mixed element type meshes yet')
        return
      end
      obj.fem = mp.FEM.FemType.fromId(ct(1));
    end
    function [xyz] = transform(obj, refPoint, cellID)
      % Return real coordinates for point with reference coordinates in given element
      cellNodes = obj.cellToNodes.at(cellID);
      refXYZ = obj.mesh.nodes(cellNodes, :);
      sf = obj.fem.sfh(refPoint);
      xyz = [sf*refXYZ(:,1), sf*refXYZ(:,2), sf*refXYZ(:,3)];
    end
    function [jmat] = jacobianMatrix(obj, refPts, cellID, displacement)
      % calcualte jacobian matrix of the geometric transformation at reference
      % points of given cell.
      cellNodes = obj.cellToNodes.at(cellID);
      refXYZ = obj.mesh.nodes(cellNodes, :);
      n = size(displacement,2);
      if nargin > 3
        refXYZ(:, 1:n) = refXYZ(:, 1:n) + displacement(cellNodes, :);
      end
      npt = size(refPts, 1);
      d = obj.mesh.dim;
      jmat = zeros(d, obj.dim, npt);
      for k = 1:size(refPts, 1)
        sfD = obj.fem.sfDh(refPts(k,:));
        jmat(:,:,k) = sfD*refXYZ(:, 1:obj.dim);
      end
    end
    function [jac] = jacobian(obj, refPts, cellID, displacement)
      % calcualte jacobian of the geometric transformation
      jmat = obj.jacobianMatrix(obj, refPts, cellID, displacement)
      n = size(jmat, 3);
      jac = zeros(1, n);
      for i=1:jmat
        jac = obj.jacobian1D(jmat(:,:, i));
      end
    end
  end
  methods(Access=private)
    function [d] = jacobian1D(jmat)
      d = sqrt(sum(jmat.*jmat));
    end
    function [d] = jacobian2D(jmat)

    end
  end
end
