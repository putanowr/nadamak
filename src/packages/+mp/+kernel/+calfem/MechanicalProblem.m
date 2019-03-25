classdef MechanicalProblem < mp.MechanicalProblem 
  % Mechanical problem calss
  properties(Constant)
    validFemTypes = [mp.FEM.FemType.Line2, mp.FEM.FemType.Triang3, mp.FEM.FemType.Quad4];
    validGmshTypes = [1,2,3];
  end
  properties(Access=private)
    bcT
  end
  methods
    function [obj] = MechanicalProblem(geometry)
      obj = obj@mp.MechanicalProblem(geometry);
      obj.bcT = [];
    end
    function [status] = isValidFem(obj, fem)
      % Return true if Fem is valid for this problem, that means it is 
      % supported by assembly procedures
      status = ismember(fem.femType, obj.validFemTypes);
    end
    function [status] = isValidGmshElement(obj, gmshType)
      % Return true is mesh element type is valid for this problem, that
      % is it is supported by assembly procedures
      status = ismember(gmshType, obj.validGmshTypes);
    end
     
    function preassembly(obj, options)
      n = obj.model.numOfDofs;
      obj.bcT = zeros(n,2);
      obj.model.K = zeros(n,n);
      obj.model.F = zeros(n,1);
      obj.progress.report([], 'Allocating global matrices');
    end
    function assemblyKinematicBC(obj)
      callback = @obj.kinematicBCHandler;
      obj.bc.apply(callback);
    end
    function handleBcDisplacement(obj, regionName, bc)
      fprintf('Handled %s on %s\n', bc.type, regionName);
      variable = obj.model.variables.get(bc.variable);
      fem = variable.fem; 
      mesh = fem.mesh;
      regionId = mesh.findRegions(struct('name', {{regionName}}));
      for e = mesh.findElems(struct('region', regionId))
         fprintf(1, 'For element %d\n', e)
         elemDofs = fem.dofs{e};
         for d = elemDofs
           fprintf(1, ' %d', d);
         end
         fprintf(1, '\n');
         dofdim = fem.dimOfDof(elemDofs, variable.offset);
         for d = dofdim
           fprintf(1, ' %d', d);
         end
         fprintf('\n');
         obj.bcT(elemDofs,2) = bc.value(dofdim);
         obj.bcT(elemDofs,1) = elemDofs;
         obj.bcT
      end
    end
    function kinematicBCHandler(obj, regionName, bc)
       if strcmp(bc.variable, 'Displacement')
        switch(bc.type)
          case mp.BcType.Displacement
            obj.handleBcDisplacement(regionName, bc);
        end
       end
    end
    function assembly(obj, options)
      mesh = obj.model.meshes.get('mainmesh');
      c2v = mesh.getAdjacency(mp.Topo(mesh.dim), mp.Topo.Vertex);
      nelems = mesh.perDimCount(mesh.dim);
      variable = obj.model.variables.get('Displacement');
      fem = variable.fem;
      if ~obj.isValidFem(fem)
        error('Fem %s is not supported by Calfem kernel', fem.type);
      end
      pf = obj.progress.fraction;
      obj.progress.report(0, 'Star global matrix assembly');
      progChunk = 10;
      ip = floor(nelems/progChunk);
      pr = 0;
      for i=1:nelems
        elem = mesh.elemsFromIds(i);
        type  = mesh.elementGmshType(elem);
        if ~obj.isValidGmshElement(type)
          error('Gmsh element type %d is not supported by Calfem kernel');
        end
        nodes = c2v.at(i);
        Ke = obj.localStiffnessMatrix(i, elem, type, nodes);
        dofs = fem.dofs{elem}'
        obj.model.K = assem([1,dofs], obj.model.K, Ke);
        if i/nelems> pr/progChunk
          pr = pr+1;
          msg = sprintf('Assembling matrices %d%%',pr/progChunk*100);
          obj.progress.reportOnlyGUI(pr/progChunk, msg);
        end
      end
      obj.progress.report(pf, 'Assembly finished');
      obj.assemblyKinematicBC();
      obj.bcT(obj.bcT(:,1)~=0,:)
    end
    function Ke = localStiffnessMatrix(obj, id, elem, type, nodes)
       n = numel(nodes)*2;
       Ke = ones(n,n);
    end
  end
end
