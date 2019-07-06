classdef MeshIm < handle
  % MeshIm holds association between mesh elements and integration rules.
  properties (SetAccess=private)
    mesh % reference to the underlying mesh
    region % region ID of the mesh
    quadratures
    elemType2quad
  end
  methods
    function [obj] = MeshIm(mesh, region, order)
      obj.mesh = mesh;
      obj.region = region;
      obj.quadratures = cell();
      obj.elemType2quad = containers.Map('KeyType', 'int32', ...
                                         'ValueType', 'int32');
      obj.setup(order);
    end
  end
  methods(Access=private)
    function setup(obj, order)
      nelem = obj.mesh.countElems();
      for i=1:nelem
        et = obj.mesh.elementGmshType(i);
        if ~obj.elemType2quad.isKey(et)
          obj.quadratres{end} = mp.IM.QuadratureFactory(et, order);
          obj.elemType2quad(et) = numel(obj.quadratures);
        end
      end
    end
  end
end  

