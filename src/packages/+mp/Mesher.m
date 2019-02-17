classdef Mesher < handle
  % Manages mesh generation process 
  properties (Access=public)
    basename = 'mesherinput';
    folder = tempdir();
    clean = true;
    dim = 2;
    order = 1;
    quadsonly = false;
    transfinite = false;
    transres = [1,1];
    useGlobalField = false;
    showinfo = false;
    verbosity = 5;
    regionsToMesh = {};
  end
  methods
    function [obj] = Mesher(varargin)
      mp_setup_gmsh();
      if nargin > 1
        obj.folder = mp_meshingOptions_folder(varargin{1});
        obj.basename = mp_meshingOptions_basename(varargin{1});
        obj.dim = mp_meshingOptions_dim(varargin{1});
      end  
    end
    function [mesh] = generate(obj, geometry, params)
      if nargin < 3
        params.lc = geometry.coarsest_lc();
        params.quadsonly = false;
        params.meshall = true;
        params.transres = [1,1];
        params.transfinite = false;
      end
      geomgmsh = mp_tpl_substitute(geometry.as_gmsh(), params);
      if obj.useGlobalField
        bgf = obj.fieldsData(params);
        geomgmsh = [geomgmsh, newline, bgf];
      end
      meshingParam.dim = mp_get_option(params, 'dim', obj.dim);
      meshingParam.clean = obj.clean;
      meshingParam.lc = params.lc;
      meshingParam.order = mp_get_option(params, 'order', obj.order);
      meshingParam.transfinite = mp_get_option(params, 'transfinite', obj.transfinite);
      meshingParam.transres = mp_get_option(params, 'transres', obj.transres);
      meshingParam.showinfo = mp_get_option(params, 'showinfo', obj.showinfo);
      meshingParam.verbosity = mp_get_option(params, 'verbosity', obj.verbosity);
      meshingParam.regionsToMesh = mp_get_option(params, 'regionsToMesh', obj.regionsToMesh);
      if isempty(meshingParam.regionsToMesh)
        meshingParam.meshall=1;
        meshingParam.regionsToMesh='all';
      else
        meshingParam.meshall=0;
      end
      [n,e,r,m] = mp.gmsh.generate(geomgmsh, meshingParam);
      mesh = mp.Mesh(meshingParam.dim, n,e,r,m);
    end
    function [refmesh] = refine(obj, mesh, nrefinements)
      if nargin < 3
        nrefinements = 1;
      end
      inputFile = fullfile(obj.folder, [obj.basename, '_orig.msh']);
      outputFile = fullfile(obj.folder, [obj.basename, '_ref.msh']);
      mesh.write(inputFile);
      meshingParams.nrefinements = nrefinements;
      mp_gmsh_refine(inputFile, outputFile, meshingParams);
      refmesh = mp.readMesh(outputFile);
      if obj.clean
        delete(inputFile);
        delete(outputFile);
      end
    end
  end
  methods (Access=private)
    function str=fieldsData(obj, meshingParams)
      F = mp_get_option(meshingParams, 'globalField', '1');
      if isnumeric(F)
        F = sprintf('%f', F);
      end
      fmt = 'Field[1]=MathEval;\nField[1].F="%s";\nBackground Field=1;\n';
      str = sprintf(fmt, F);
      str = [str, sprintf('Mesh.CharacteristicLengthFromPoints=0;\n')];
    end
  end
end
