function [dofsCount]=countDisplacedDofs(mesh, bc)
  % Return number of nodes with Displacement boundary conditions.
  % CAUTION : this should be distinguished from Fixture nodes, that
  % is nodes with boundary conditions of FixedX, etc.
  % The difference is that the Displacement value can be any number while
  % in the fictures it is strictly zero.
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Displacement, 'Displacement');
  dofsCount = 0;
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', {regname}));
    for n = nodes
      for d = 1:mesh.ambientDim
        if ~ismissing(bcond.value(d))
          dofsCount = dofsCount+1;
        end  
      end
    end
  end
end
