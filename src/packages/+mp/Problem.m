classdef Problem < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=protected)
    type mp.ProblemType
    model mp.FemModel
    geometry
    progress mp.Progress
    bc mp.BcRegistry
    variables
  end
  properties(Constant)
    validExports = {'FlagSHyp'}; % names of valid export formats
  end
  methods(Abstract)
    [] = setupVariables(obj)
  end
  methods
    function [obj] = Problem(type_, geometry)
      obj.type = type_;
      if nargin > 1
        obj.setGeometry(geometry);
      end
      obj.progress = mp.Progress();
      obj.model = mp.FemModel();
      obj.bc = mp.BcRegistry();
      obj.setupVariables();
    end
    function exportToProject(obj, project)
      project.data.GeometryType = obj.geometry.projectName;
      project.data.ProblemType = char(obj.type);
      obj.bc.exportToProject(project);
    end
    function [status, msg] = export(obj, format, fpath)
      % export - saves Project data in specified format in file
      %   Arguments:
      %      format - name of export format. Valid names are
      %               available as property validExports
      %      fpath - file path
      %   Return:
      %      status - boolean
      %      msg - message describin action or cause of error
      %
      % Note: this function check for valid export formats
      status = false;
      msg = 'Internal error: exporting Problem failed';
      if ismember(format, obj.validExports)
        if strcmp(format, 'FlagSHyp')
          [status, msg] = obj.exportFlagSHyp(fpath);
        end
      else
        status = false;
        vf = strjoin(obj.validExports, '\n');
        msg = sprintf('Invalid export format : %s\nValid formats: %s', format, vf);
      end
    end
    function [status, msg] = exportFlagSHyp(obj, fpath)
      status = true;
      msg = 'Export successful';
      fid = fopen(fpath, 'w');
      mesh = obj.model.meshes.get('mainmesh');
      mp.exports.flagshyp.writeMesh(fid, mesh, obj.bc);
      mp.exports.flagshyp.writeMaterialData(fid);
      mp.exports.flagshyp.writeLoadingData(fid, mesh, obj.bc);
      mp.exports.flagshyp.writePointLoads(fid, mesh, obj.bc);
      mp.exports.flagshyp.writePrescribedDisplacements(fid, mesh, obj.bc);
      mp.exports.flagshyp.writePressureLoads(fid, mesh, obj.bc);
      mp.exports.flagshyp.writeSolutionParameters(fid);
      fclose(fid);
    end
    function vars = variableNames(obj)
      vars= fieldnames(obj.variables)';
    end
    function writeDofs(obj, fid)
      obj.model.writeDofs(fid);
    end
    function writeBc(obj, fid)
      obj.bc.writeBc(fid);
    end
    function setBc(obj, regionName, bc)
      obj.bc.register(regionName, bc);
    end
    function bc = getBc(obj, regionName, variableName)
      % Return boundary condition on given region for given variable.
      % If variableName is empty or not set then it returns struct
      % of all boundary conditions set on given region.
      bc = obj.bc.get(regionName, variableName);
    end
    function status = hasBc(obj, region, variableName)
      status = obj.bc.hasBc(region, variableName);
    end
    function setProgressReporter(obj, reporter)
      obj.progress = reporter;
    end
    function setGeometry(obj, geometry)
      if ischar(geometry)
        obj.geometry = mp.GeomFactory.produce(geometry);
      else
        obj.geometry = geometry;
      end
    end
    function [info] = meshInfo(obj, meshName)
      if obj.model.meshes.hasMesh(meshName)
        mh = obj.model.meshes.get(meshName);
        nnodes = mh.countNodes();
        nelems = mh.countPerDim(obj.geometry.dim);
        info = sprintf('Nodes: %d  Elements %d', nnodes, nelems);
      else
        info = sprintf('Error: no mesh called %s', meshName);
      end
    end
    function [status] = hasMesh(obj, meshName)
      if nargin < 2
        meshName = 'mainmesh';
      end
      status = obj.model.meshes   .hasMesh(meshName);
    end
    function [mesh] = getMesh(obj, meshName)
      mesh = obj.model.meshes.get(meshName);
    end
    function registerMesh(obj, mesh, meshName)
      msg = sprintf('Registering mesh as: %s', meshName);
      obj.progress.report(obj.progress.fraction, msg);
      obj.model.meshes.register(mesh, meshName);
    end
    function solve(obj, options)
      obj.model.resetVariables();
      obj.buildMeshes(options);
      obj.setupApproximation(options);
      obj.preassembly(options);
      obj.assembly(options);
      obj.runSolver();
      obj.postprocess();
    end
    function [status, msg] = buildMeshes(obj, options)
      rebuildMesh = mp_get_option(options, 'RebuildMesh', false);
      msg = 'No main mesh --- building one';
      if obj.model.meshes.hasMesh('mainmesh')
        if ~rebuildMesh
          status = true;
          msg = 'Main mesh already exists, not rebuilding';
          obj.progress.report([], msg);
          return
        else
          msg = 'Rebuilding existing main mesh';
          rebuildMesh = true;
        end
      else
        rebuildMesh = true;
      end
      obj.progress.report([], msg);
      if rebuildMesh
        if ~isfield(options, 'MeshingOptions')
          msg = 'Mesh rebuilding requested but no MeshingOptions given --- aborting';
          error(msg);
        end
        mesher = mp.Mesher();
        mesh = mesher.generate(obj.geometry, options.MeshingOptions);
        obj.registerMesh(mesh, 'mainmesh');
        msg = 'Mesh generated OK';
        status = true;
        obj.progress.report([], msg);
      end
    end
    function preassembly(obj, options)
      obj.progress.report(0.2, 'Do pre-assembly');
    end
    function assembly(obj, options)
      obj.progress.report(0.3, 'Assembly');
    end
    function runSolver(obj, options)
      obj.progress.report(0.6, 'Run solver');
    end
    function postprocess(obj)
      obj.progress.report(0.8, 'Postprocess');
    end
    function setupApproximation(obj, options)
      obj.progress.report(0.2, 'Setup approximation')
      for vn = fieldnames(obj.variables)'
        variableName = vn{:};
        var = obj.variables.(variableName);
        fem = obj.model.addIsoparametricFem(variableName, 'mainmesh', var.qdim);
        modelVariable = mp.ModelVariable(var, struct('fem', fem));
        obj.model.variables.addVariable(modelVariable);
        msg = sprintf('Added model variable %s with %d DOFS', variableName, modelVariable.numOfDofs());
        obj.progress.report([], msg);
      end
    end
  end
end
