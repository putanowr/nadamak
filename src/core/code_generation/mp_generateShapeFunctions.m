function status = mp_generateShapeFunctions(pth)
% Write *.m files with definition of shape functions for Nadamak FEMs.
    syms x y z
    sfDefs.Line2.sf = [1-x, x];
    sfDefs.Quad4.sf = [(1-x).*(1-y), x.*(1-y),x.*y, y.*(1-x)];
    sfDefs.Triang3.sf = [z, x, y];
    sfDefs.Triang6.sf = [z.*(z-y-x), x.*(x-z-y), y.*(y-x-z),4*x.*z,4*y.*x,4*y.*z];
    sf = sym('sf', [1,10]);
    sf(1)  = z.*(3*z - 1).*(3*z - 2)/2;
    sf(2)  = x.*(3*x - 1).*(3*x - 2)/2;
    sf(3)  = y.*(3*y - 1).*(3*y - 2)/2;
    sf(4)  = 9*z.*x.*(3*z - 1)/2;
    sf(5)  = 9*z.*x.*(3*x - 1)/2;
    sf(6)  = 9*x.*y.*(3*x - 1)/2;
    sf(7)  = 9*x.*y.*(3*y - 1)/2;
    sf(8)  = 9*y.*z.*(3*y - 1)/2;
    sf(9)  = 9*y.*z.*(3*z - 1)/2;
    sf(10) =  27*x.*y.*z;
    sfDefs.Triang10.sf = sf;
       
    fprintf('Generating code for shape functions in : %s\n', pth);
    for fem = enumeration('mp.FEM.FemType')'
        name = sprintf('%s', fem);
        fprintf('   Generate shape functions for : %s\n', name);
        writeSf(sfDefs.(name), name, pth);
    end
    status = true;
end

function writeSf(sfDef, name, pth)
  syms x y z w
  fem = mp.FEM.FemType(name);
  if length(sfDef.sf) ~= fem.numOfDofs
      error('Number of shape functions %d not equal to number of DOFs: %d',...
          length(sfDef), fem.numOfDofs);
  end
  fname = sprintf('sf%s.m', name);
  fpath = fullfile(pth, fname);
  aa = sym('x', [1,3]);
  switch(fem.dim)
      case 1
        fs(x) = sfDef.sf;
        matlabFunction(fs(aa(1)), 'file', fpath, 'var', {aa});
      case 2
        fs(x,y) = subs(sfDef.sf, z, 1-x-y);
        matlabFunction(fs(aa(1), aa(2)), 'file', fpath, 'var', {aa});
      case 3  
        fs(x,y,z) = subs(sfDef.sf, w, 1-x-y-z);
        matlabFunction(fs(aa(1), aa(2), aa(3)), 'file', fpath, 'var', {aa});
  end
end