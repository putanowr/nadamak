function [outstr] = mp_gmsh_augment_geomodel(template, context)
% Add geometric model template with several setting affecting
% how the mesh is generated. The settings are parametrized.
  augmentstr = 'Mesh.ElementOrder = <elementOrder>;';
  c = newline;
  outstr = [template,c,augmentstr];
end
