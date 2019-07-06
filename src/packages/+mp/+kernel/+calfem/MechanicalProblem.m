classdef MechanicalProblem < mp.MechanicalProblem 
  % Mechanical problem calss
  properties(Constant)
    validFemTypes = [mp.FEM.FemType.Line2, mp.FEM.FemType.Triang3,...
                     mp.FEM.FemType.Quad4, mp.FEM.FemType.Quad8,...
                     mp.FEM.FemType.Hex8];
    validGmshTypes = [1,2,3,16,5];
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
      obj.bcT = obj.bcT(obj.bcT(:,1)~=0,:);
    end
    function handleBcDisplacement(obj, regionName, variableName, bcValue, dimMask)
      if nargin < 5
        dimMask =[];
      end
      variable = obj.model.variables.get(variableName);
      fem = variable.fem; 
      mesh = fem.mesh;
      regionId = mesh.findRegions(struct('name', {{regionName}}));
      for e = mesh.findElems(struct('region', regionId))
         elemDofs = fem.dofs{e};
         dofdim = fem.dimOfDof(elemDofs, variable.offset);
         if ~isempty(dimMask)
           elemDofs = elemDofs(dofdim==dimMask);
           dofdim = dofdim(dofdim==dimMask);
         end
         obj.bcT(elemDofs,2) = bcValue(dofdim);
         obj.bcT(elemDofs,1) = elemDofs;
      end
    end
    function kinematicBCHandler(obj, regionName, bc)
      if strcmp(bc.variable, 'Displacement')
        switch(bc.type)
          case mp.BcType.Displacement
            obj.handleBcDisplacement(regionName, bc.variable, bc.value);
          case mp.BcType.Fixity
            obj.handleBcDisplacement(regionName, bc.variable, [0,0,0]);
          case mp.BcType.FixityX
            obj.handleBcDisplacement(regionName, bc.variable, [0,0,0], 1);
          case mp.BcType.FixityY
            obj.handleBcDisplacement(regionName, bc.variable, [0,0,0], 2);
          case mp.BcType.FixityZ
            obj.handleBcDisplacement(regionName, bc.variable, [0,0,0], 3);
          otherwise
            error('Invalid type of kinemantic boundary condition :%s', bc.type)
        end
      end
    end
    function assembly(obj, options)
      mesh = obj.model.meshes.get('mainmesh');
      c2v = mesh.getAdjacency(mp.Topo(mesh.dim), mp.Topo.Vertex);
      nelems = mesh.countPerDim(mesh.dim);
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
        Ke = obj.localStiffnessMatrix(mesh, elem, fem.femType, nodes);
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
 
    end
    function Ke = localStiffnessMatrix(obj, mesh, elem, femType, nodes)
       E = 210e6;
       nu = 0.2;
       if mesh.dim == 3
         ptype = 4;
       else
         ptype = 2; % plane Strain
       end
       D = hooke(ptype, E, nu);
       n = numel(nodes)*2;
       thickness = 1;
       nGauss = 2;
       coords = mesh.nodes(nodes,:)';
       ex = coords(1,:);
       ey = coords(2,:);
       ez = coords(3,:);
       switch femType
         case mp.FEM.FemType.Triang3
           ep = [ptype, thickness];
           Ke = plante(ex,ey,ep, D);
         case mp.FEM.FemType.Quad4
           ep = [ptype, thickness, nGauss];
           Ke = plani4e(ex,ey,ep,D);
         case mp.FEM.FemType.Quad8
           ep = [ptype, thickness, nGauss];
           Ke = plani8e(ex,ey,ep,D);
         case mp.FEM.FemType.Hex8
           ep = nGauss;
           Ke = soli8e(ex,ey,ez,ep,D);
         otherwise
           error('Calfem kernel does not support Fem of type: %s', femType);
       end  
       disp(Ke)
     end
    function runSolver(obj, options)
      sol = solveq(obj.model.K, obj.model.F, obj.bcT);
      fprintf('Running Calfem solver')
      bt = obj.bcT
      variable = obj.model.variables.get('Displacement');
      nd = variable.numOfDofs();
      of = variable.offset;
      variable.dofValues = sol(1+of:(of+nd));
      disp(variable.fem.mesh.nodes.Data)
    end
  end
end
