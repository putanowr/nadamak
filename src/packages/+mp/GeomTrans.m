classdef GeomTrans < handle
  %GeomTrans - performs geometric transformation from reference to real element.
  properties (SetAccess=private)
    mesh
    fem
    cellToNodes
    dim
    ambientDim
  end
  methods
    function [obj] = GeomTrans(mesh, refDim)
      if nargin < 2
        obj.dim = mesh.dim;
      else
        obj.dim = refDim;
      end
      obj.ambientDim = mesh.ambientDim;
      if (obj.dim > obj.ambientDim || obj.dim < 1)
        error('Invalid GeomTrans dimension %d, expected value in range [1, %d]', obj.dim, obj.ambientDim)
      end
      obj.mesh = mesh;
      obj.cellToNodes = mesh.getAdjacency(obj.dim, 0);
      ct = mesh.cellTypes(obj.dim);
      if (length(ct) > 1)
        % error('GeomTrans not cannot handle mixed element type meshes yet')
        return
      end
      obj.fem = mp.FEM.FemType.fromId(ct(1));
    end
    function [xyz] = transform(obj, refPoint, cellID, displacement)
      % Return real coordinates for point with reference coordinates in given element
      cellNodes = obj.cellToNodes.at(cellID);
      ambientXYZ = obj.mesh.nodes(cellNodes, :);
      if nargin > 3 && ~isempty(displacement)
        n = size(displacement,2);
        ambientXYZ(:, 1:n) = ambientXYZ(:, 1:n) + displacement(cellNodes, :);
      end
      sf = obj.fem.sfh(refPoint);
      xyz = sf*ambientXYZ;
    end
    function [jmat] = jacobianMatrix(obj, refPts, cellID, displacement)
      % Calcualte Jacobian matrix of the geometric transformation at reference
      % points of given cell.
      % The calculated matrix is 3D. If J_ijk is calculated Jacobina matrix
      % then index i corresponds to component of the transformation, index
      % j corresponds to the variable over which derivative is take and
      % index k corresponds to the point at which Jacobina matrix is
      % calcualted.
      % Ths size of J is [ambientDim, dim, size(refPts, 1)].
      % The slices along k axis give the traditional Jacobina matrix
      %    df_1/dx_1, df_1/dx2, ..., df_1/dx_k
      %    ...
      %    df_n/dx_1, df_n/dx2, ..., df_n/dx_k
      %
      cellNodes = obj.cellToNodes.at(cellID);
      ambientXYZ = obj.mesh.nodes(cellNodes, :);
      n = size(displacement,2);
      if nargin > 3 && ~isempty(displacement)
        ambientXYZ(:, 1:n) = ambientXYZ(:, 1:n) + displacement(cellNodes, :);
      end
      npt = size(refPts, 1);
      jmat = zeros(obj.ambientDim, obj.dim, npt);
      for k = 1:size(refPts, 1)
        sfD = obj.fem.sfDh(refPts(k,:));
        jmat(1:obj.dim,:,k) = (sfD*ambientXYZ(:, 1:obj.dim))';
      end
    end
    function [form] = volumeFormOnEdge(obj, refPts, cellID, edgeID, displacement)
       info = obj.fem.getInfo();
       edge = info.edges{edgeID};
       pt1 = info.nodes(edge(1),:);
       pt2 = info.nodes(edge(end),:);
       n = size(refPts, 1);
       form = zeros(1, n);
       dstdxi = pt2 - pt1;
       dstdxi = dstdxi(1:obj.dim)';
       % Map Gauss points onto edge.
       p = pt1.*(1-refPts(:,1))+pt2.*(refPts(:,1));
       jmat = obj.jacobianMatrix(p, cellID, displacement);      
       for i=1:n
          df = jmat(:,:, i)*dstdxi;
          form(i) = sqrt(det(df'*df));
       end
    end   
    function [form] = volumeForm(obj, refPts, cellID, displacement)
      % Calculate pulback of volume form under displacement map
      % onto reference element.
      jmat = obj.jacobianMatrix(refPts, cellID, displacement);
      n = size(jmat, 3);
      form = zeros(1, n);
      for i=1:n
        df = jmat(:,:, i);
        form(i) = sqrt(det(df'*df));
      end
    end
  end
end

