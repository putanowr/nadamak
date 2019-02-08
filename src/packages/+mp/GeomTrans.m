classdef GeomTrans < handle
  %GeomTrans - performs geometric transformation from reference to real element. 
  properties (Access=private)
    mesh
    sfEvaluator  
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
      switch ct(1)
        case 1
           obj.sfEvaluator = @mp.FEM.sfLine2;
        case 2
           obj.sfEvaluator = @mp.FEM.sfTri3;
        case 9
           obj.sfEvaluator = @mp.FEM.sfTri6;
        case 3
           obj.sfEvaluator = @mp.FEM.sfQuad4;  
        otherwise
          error('GeomTrans cannot handle element type %d', ct(1))
      end
    end
    function [xyz] = transform(obj, refPoint, cellID)
      % Return real coordinates for point with reference coordinates in given element
      cellNodes = obj.cellToNodes.at(cellID);
      refXYZ = obj.mesh.nodes(cellNodes, :);
      shapeFun = obj.sfEvaluator;
      sf = shapeFun(refPoint);
      xyz = [dot(sf, refXYZ(:,1)), dot(sf, refXYZ(:,2)), dot(sf, refXYZ(:,3))]; 
    end
  end
end
