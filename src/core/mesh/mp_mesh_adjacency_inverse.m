function [invAdj] = mp_mesh_adjacency_inverse(adjacency, varargin)
  if nargin > 1
    invAdj = mp_mesh_adjacency_inverse_continuous(adjacency, varargin(1));
  else
    invAdj = mp_mesh_adjacency_inverse_discontinuous(adjacency);
  end
end

function [invAdj] = mp_mesh_adjacency_inverse_continuous(adjacency, nnodes)
%% Calculate inverse of adjacency relation
%
% Argument - cell array with adjacency info
%
   invAdj = cell(nnodes, 2);
   invAdj(:, 1) = mat2cell((1:nnodes)', ones(1,nnodes));
   n = size(adjacency, 1);
   for i=1:n
     elem = adjacency{i, 1};
     nodes = adjacency{i, 2};
     for nk = nodes
       t = tag(nk);
       if isfield(map, t)
         map.(t) = [map.(t), elem];
       else
         map.(t) = [elem];
         nnodes = nnodes+1;
       end
     end
   end
   fn = fieldnames(map);
   invAdj(:, 1) = cellfun(@(z) untag(z), fn, 'UniformOutput', false);
   invAdj(:, 2) = cellfun(@(z) map.(z),  fn, 'UniformOutput', false);
end

function [invAdj] = mp_mesh_adjacency_inverse_discontinuous(adjacency)
   persistent tag
   persistent untag
   if isempty(tag)
     tag = @(k) sprintf('t%d',k);
   end
   if isempty(untag)
     untag = @(t) str2num(t(2:end));
   end
   map = struct();
   n = size(adjacency, 1);
   nnodes = 0;
   for i=1:n
     elem = adjacency{i, 1};
     nodes = adjacency{i, 2};
     for nk = nodes
       t = tag(nk);
       if isfield(map, t)
         map.(t) = [map.(t), elem];
       else
         map.(t) = [elem];
         nnodes = nnodes+1;
       end
     end
   end
   invAdj = cell(nnodes, 2);
   fn = fieldnames(map);
   invAdj(:, 1) = cellfun(@(z) untag(z), fn, 'UniformOutput', false);
   invAdj(:, 2) = cellfun(@(z) map.(z),  fn, 'UniformOutput', false);
end