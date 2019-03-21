classdef GeomTrans < handle
  %GeomTrans - performs geometric transformation from reference to real element.
  properties (SetAccess=private)
    mesh
    fem
    cellToNodes
  end
  methods
    function [obj] = GeomTrans(mesh)
      obj.mesh = mesh;
      dim = mesh.dim;
      obj.cellToNodes = mesh.getAdjacency(dim, 0);
      ct = mesh.cellTypes();
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
    function [jmat] = jacobian(obj, refPts, cellID, displacement)
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
      jmat = zeros(d, d, npt);
      k = 1;
      for k = 1:size(refPts, 1);
        sfD = obj.fem.sfDh(refPts(k,:));
        jmat(:,:,k) = sfD*refXYZ(:, 1:d);
      end
    end
  end
end
