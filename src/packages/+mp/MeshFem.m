classdef MeshFem < handle
  % MeshFem holds association between mesh elements and set of approximation
  % functions spanned over the elements.
  properties (SetAccess=private)
    mesh % reference to the underlying mesh
    region % region ID of the mesh
    isUniform = true;
    qdim
    femType
    dofs
    nodes2dofs
    numOfDofs
  end
  methods
    function [obj] = MeshFem(mesh, region, femType, qdim)
      obj.mesh = mesh;
      obj.qdim = qdim;
      obj.region = region;
      obj.isUniform = true;
      obj.femType = femType;
      if ~femType.isLagrangian
        error('Non Lagrangian finite elements are not supported yet')
      end
      obj.numOfDofs = 0;
    end
    function ndof = enumerateDofs(obj)
      if obj.numOfDofs == 0
        dim = obj.mesh.dim;
        obj.enumerateClassicNodalC();
        ndof = obj.numOfDofs;
      end
    end
    function n = nodeOfDof(obj, localDofID, elemID)
      if obj.isLagrangian
        qp = prod(obj.qdim);
        n = floor((localDofID-1)/qp)+1;
      else
        error('Element is not Lagranian');
      end
    end
    function realPt = pointOfDof(obj, localDofID, elemID)
      qp = prod(obj.qdim);
      id = floor((localDofID-1)/qp)+1;
      refPt = obj.femType.pointOfDof(id);
      realPt = obj.mesh.geomTrans.transform(refPt, elemID);
    end
    function locDofs = localDofsOfPoint(obj, point, elemID)
      locDofs = zeros(0,0, 'uint32'); % local degrees of freedom in element
      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
      for i=1:dofsPerElem
        realPt = obj.pointOfDof(i, elemID);
        if norm(point-realPt) < 1e-5
          locDofs = [locDofs, i];
        end
      end
    end
    function id = hasDofAtPoint(obj, point, elemID, dofDim)
      id = 0;
      for i=1:obj.femType.numOfDofs
        realPt = obj.pointOfDof(i, elemID);
        if norm(point-realPt) < 1e-5
          id = i;
          break;
        end
      end
      if id ~= 0
        id = (dofDim-1)*obj.femType.numOfDofs+id;
      end
    end
    function globDofs = globalDofsOfPoint(obj, point, elemID)
      %%Return vector of dofs associated with given point
      globDofs = [];
      if ~isempty(obj.dofs)
        globDofs = obj.dofs(elemID, obj.localDofsOfPoint(point, elemID));
      end
    end
    function d = dimOfDof(obj, dofID, offset)
      % Return component number of dof
      di = dofID-offset;
      qp = prod(obj.qdim);
      d=rem((di-1),qp)+1;
    end
    function writeDofs(obj, fid)
      i=0;
      for edof = obj.dofs
        i=i+1;
        fprintf(fid, 'Elem %d dofs  ', i);
        for dof = edof{:}
          fprintf(fid, ' %d', dof);
        end
        fprintf(fid, '\n');
      end
    end
    function [N] = matrixN(obj, refPts)
      % Calculate matrix of shape functions
      dofPerElem = obj.qdim * obj.femType.numOfDofs;
      N = zeros(obj.qdim, dofPerElem);
      error('NOT FINISHED'); % FIXME
    end
  end
  methods(Access=private)
    function enumerateClassicNodalC(obj)
      nelem = obj.mesh.elemsCount();
      obj.dofs = cell(1,nelem);
      nnodes = obj.mesh.nodesCount();
      qd = prod(obj.qdim);
      obj.nodes2dofs = zeros(qd, nnodes, 'uint32');
      totalDofs= 0;
      for i=1:nelem
        nodes = obj.mesh.elemNodes(i);
        notSet = find(~all(obj.nodes2dofs(:, nodes)));
        notSetNum = numel(notSet);
        if notSetNum > 0
          globDofs = zeros(qd, notSetNum, 'uint32');
          numNewDofs= notSetNum*qd;
          globDofs(:) = (1:(numNewDofs))+totalDofs;
          totalDofs = totalDofs+numNewDofs;
          sel = nodes(notSet);
          obj.nodes2dofs(:,sel) = globDofs;
        end
        dummy = obj.nodes2dofs(:, nodes);
        obj.dofs{i} = dummy(:);
      end
      obj.numOfDofs = totalDofs;
    end
    function enumerateClassicNodal(obj)
      dim = obj.mesh.dim;
      nelem = obj.mesh.elemsCount(struct('dim', dim));
      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
      obj.dofs = zeros(dofsPerElem, nelem, 'uint32');
      c2v = obj.mesh.getAdjacency(mp.Topo(dim), mp.Topo.Vertex);
      nnodes = obj.mesh.nodesCount();
      qd = prod(obj.qdim);
      nodes2dofs = zeros(qd, nnodes);
      totalDofs=0;
      for i=1:nelem
        cellNodes = c2v.at(i);
        % find all nodes in cell that do not have global dofs set
        notSet = find(~all(nodes2dofs(:, cellNodes)));
        notSetNum = numel(notSet);
        if notSetNum > 0
          globDofs = zeros(qd, notSetNum);
          numNewDofs= notSetNum*qd;
          globDofs(:) = (1:(numNewDofs))+totalDofs;
          totalDofs = totalDofs+numNewDofs;
          sel = cellNodes(notSet);
          nodes2dofs(:,sel) = globDofs;
        end
        dummy = nodes2dofs(:, cellNodes);
        obj.dofs(:, i) = dummy(:);
      end
      obj.numOfDofs = totalDofs;
    end
    function ndof = enumerateGeneric(obj)
      dim = obj.mesh.dim;
      nelem = obj.mesh.elemsCount(struct('dim', dim));
      dofCounter = uint32(offset);
      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
      obj.dofs = zeros(dofsPerElem, nelem, 'uint32');
      ddim = obj.dimOfDof(1:dofsPerElem);
      for elemID=1:nelem
        for dofID=1:dofsPerElem
          if obj.dofs(dofID, elemID) ~= 0
            continue
          end
          realPt = obj.pointOfDof(dofID, elemID);
          dofTopo = obj.femType.topoOfDof(dofID);
          baseAdj = obj.mesh.getAdjacency(dim, dofTopo(1));
          targAdj = obj.mesh.getAdjacency(dofTopo(1), dim);
          ba = baseAdj.at(elemID);
          neighbours = targAdj.at(ba(dofTopo(2)));
          globDof = 0;
          toSet = zeros(length(neighbours),2);
          for i=1:length(neighbours)
            n = neighbours(i);
            %if n == elemID
            %  continue
            %end
            gd = obj.hasDofAtPoint(realPt, n, ddim(dofID));
            if gd
              if obj.dofs(n, gd) ~= 0
                globDof = obj.dofs(n, gd);
                %break;
              end
              toSet(i,:) = [n, gd];
            else
              fprintf('gd zero for %d %d %d\n', n, elemID, dofID')
              disp(neighbours)
            end
          end
          if globDof == 0
            dofCounter = dofCounter+1;
            globDof = dofCounter;
          end
          for i=1:size(toSet,1)
            obj.dofs(toSet(i,1), toSet(i,2)) = globDof;
          end
          %obj.dofs(elemID, dofID) = globDof;
        end % end of loop over dofs in element
      end % end of loop over elements
      ndof = numel(obj.dofs);
    end % end of function enumerateGeneric
  end
end
