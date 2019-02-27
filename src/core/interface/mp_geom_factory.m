function [geomModel] = mp_geom_factory(name)
  %% Create GeomModel from a name
  persistent registeredGeoms
  if isempty(registeredGeoms)
    registeredGeoms.rectangle       = struct('dim', 2, 'legacyID', 1, 'construct', @mp.geoms.RectangleGeom);
    registeredGeoms.square          = struct('dim', 2, 'legacyID', 2, 'construct', @mp.geoms.SquareGeom);
    registeredGeoms.beam2D          = struct('dim', 2, 'legacyID', 3, 'construct', @mp.geoms.Beam2DGeom);
    registeredGeoms.squareHole      = struct('dim', 2, 'legacyID', 4, 'construct', @mp.geoms.SquareHoleGeom);
    registeredGeoms.squareInterface = struct('dim', 2, 'legacyID', 5, 'construct', @mp.geoms.SquareInterfaceGeom);
    registeredGeoms.beam2DInterface = struct('dim', 2, 'legacyID', 6, 'construct', @mp.geoms.Beam2DInterfaceGeom);
    registeredGeoms.cube            = struct('dim', 3, 'legacyID', 1, 'construct', @mp.geoms.CubeGeom);
    registeredGeoms.beam3D          = struct('dim', 3, 'legacyID', 3, 'construct', @mp.geoms.Beam3DGeom);
    registeredGeoms.thermalSquare   = struct('dim', 2, 'legacyID', 11, 'construct', @mp.geoms.SquareGeom);
  end
  if nargin < 1
    geomModel = fieldnames(registeredGeoms);
    return
  end
  if isfield(registeredGeoms, name)
    gdata = registeredGeoms.(name);
    geomModel = gdata.construct(name, struct(), gdata.legacyID);
  else
    error('Name "%s" is not registered geometry name', name);
  end
end
