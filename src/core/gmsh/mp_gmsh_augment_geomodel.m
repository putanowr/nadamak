function [outstr] = mp_gmsh_augment_geomodel(template, context)
% Add geometric model template with several setting affecting
% how the mesh is generated. The settings are parametrized.
  augmentstr1 = 'Mesh.ElementOrder = <elementOrder>;';
  augmentstr2 = 'Mesh.SecondOrderIncomplete = <incomplete>;';
  c = newline;
  outstr = [template,c,augmentstr1,c,augmentstr2];
end
