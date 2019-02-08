function [outgeom] = mp_geom_extrude(inputgeom, xyz)

  if (length(xyz) == 1)
    xyz = [0, 0, xyz];
  end
  extrudecmd = sprintf('\n _out[] = Extrude{%g, %g, %g}{Surface{news-1};};', xyz(1), xyz(2), xyz(3) );
  volumecmd = sprintf('\nSurface Loop(newsl) = {_out}; \n Volume(newv) = { newsl-1 }; \n Physical Volume("solid") = {newv-1};\n\n');

  outgeom = [inputgeom, extrudecmd, volumecmd];
end
