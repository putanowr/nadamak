classdef MeshFactory
  methods(Static)
    function [mesh] = produce(meshname)
      [nodes, elements, regions, nodemap] = mp.meshFactoryHelper(meshname);
      mesh = mp.Mesh(2, nodes, elements, regions, nodemap);
    end  
    function [meshes] = names()
      persistent meshNames
      if isempty(meshNames)
        meshNames = {'meshA', 'meshB', 'meshC', 'meshD', 'meshE', 'meshF', ...
                     'triangle1', 'square1', 'square9', 'tritri', 'pararc'};
      end
      meshes = meshNames;
    end
  end
end
