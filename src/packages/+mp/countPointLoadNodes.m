function [nodesCount] = countPointLoadNodes(mesh, bc)
  % Return number of directly loaded nodes, that is nodes with Force boundary
  % conditions
  selector = mp.makeBcRegionsSelector(bc, mp.BcType.Force, 'Displacement');
  nodesCount = 0;
  for regname = selector.name
    bcond = bc.get(regname{:}, 'Displacement');
    nodes = mesh.findRegionNodes(struct('name', {regname}));
    nodesCount = nodesCount+numel(nodes);
  end
end
