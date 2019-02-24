classdef GeomTrans < handle
  %GeomTrans - performs geometric transformation from reference to real element. 
  properties (Access=private)
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
      sf = fem.sfh(refPoint);
      xyz = [dot(sf, refXYZ(:,1)), dot(sf, refXYZ(:,2)), dot(sf, refXYZ(:,3))]; 
    end
  end
end
