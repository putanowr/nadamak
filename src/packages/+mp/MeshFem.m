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
    end
    function enumerateDofs(obj, offset)
      dim = obj.mesh.dim;
      if dim ~= 2
        error('Enumerating DOFs implemented only for mesh dim = 2')
      end
      obj.enumerateGeneric(offset);
      return
      if obj.femType == 'Triang3' || obj.femType == 'Quad4'
        obj.enumerateClassicNodal(offset)
      elseif obj.femType == 'Triang6'
        obj.enumerateTriang6(offset)
      else
        error('Enumeration not supported for element %s', obj.femType)
      end
    end
    function realPt = pointOfDof(obj, locDofID, elemID)
      refPt = obj.femType.pointOfDof(locDofID);
      realPt = obj.mesh.geomTrans.transform(refPt, elemID);
    end
    function locDofs = localDofsOfPoint(obj, point, elemID)
      locDofs = []; % local degrees of freedom in element
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
    function d = dofDim(obj, dofID)
      d=floor((dofID-1)/obj.femType.numOfDofs)+1;
    end
  end
  methods(Access=private)
    function enumerateClassicNodal(obj, offset)
      dim = obj.mesh.dim;
      nelem = obj.mesh.elemsCount(struct('dim', dim));
      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
      obj.dofs = zeros(nelem, dofsPerElem, 'uint32');
      c2v = obj.mesh.getAdjacency(mp.Topo.Face, mp.Topo.Vertex);
      nnodes = obj.mesh.nodesCount();
      for i=1:nelem
        bn = c2v.at(i);
        cdofs = [];  
        for q = 1:obj.qdim 
          cdofs = [cdofs, bn+(q-1)*nnodes];
        end
        obj.dofs(i,:) = cdofs;
      end
      obj.dofs = obj.dofs + uint32(offset);
    end
%
%    function enumerateGeneric(obj, offset)
%      dim = obj.mesh.dim;
%      nelem = obj.mesh.elemsCount(struct('dim', dim));
%      visited = zeros(1, nelem, 'logical');
%      dofCounter = uint32(offset);
%      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
%      obj.dofs = zeros(nelem, dofsPerElem, 'uint32');
%      adj = obj.mesh.getAdjacency(dim, dim);
%      ddim = obj.dofDim(1:dofsPerElem);
%      for elemID=1:nelem
%        for dofID=1:dofsPerElem
%          realPt = obj.pointOfDof(dofID, elemID);
%          dofTopo = obj.femType.topoOfDof(
%          neighbours = adj.at(elemID);        
%          for n = neighbours
%            if visited(n) == false
%              continue
%            end
%            gd = obj.hasDofAtPoint(realPt, n, ddim(dofID));
%            if gd
%              obj.dofs(elemID, dofID) = obj.dofs(n, gd);
%              break;
%            end
%          end
%          if obj.dofs(elemID, dofID) == 0
%            dofCounter = dofCounter + 1;
%            obj.dofs(elemID, dofID) = dofCounter;
%          end
%        end
%        visited(elemID) = true;
%      end
%    end
%  
    function enumerateGeneric(obj, offset)
      dim = obj.mesh.dim;
      nelem = obj.mesh.elemsCount(struct('dim', dim));
      dofCounter = uint32(offset);
      dofsPerElem = obj.femType.numOfDofs*obj.qdim;
      obj.dofs = zeros(nelem, dofsPerElem, 'uint32');
      ddim = obj.dofDim(1:dofsPerElem);
      for elemID=1:nelem
        for dofID=1:dofsPerElem
          if obj.dofs(elemID, dofID) ~= 0
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
          toSet
          for i=1:size(toSet,1)
            obj.dofs(toSet(i,1), toSet(i,2)) = globDof;
          end
          %obj.dofs(elemID, dofID) = globDof;
        end % end of loop over dofs in element
      end % end of loop over elements
    end % end of function enumerateGeneric
  end 
end
