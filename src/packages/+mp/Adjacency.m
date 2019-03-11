classdef Adjacency < handle
  % Adjacency Represent adjacency relation between mesh entities.
  %   This class stores adjacency lists from 'source' entities to 'target'
  % 
  properties (Access=private)
    sources = uint32([]);
  end
  properties (SetAccess=private)
    targets = {};
    length = 0;
  end
  methods
    function [obj] = Adjacency(targets, sources)
      if nargin > 0
        obj.targets = targets;
        obj.length = length(targets);
        if nargin > 1
          obj.sources = sources;
          if length(sources) ~= length(targets)
            error('Incompatible size of targets %d and sources %d', ...
                length(targets), length(sources));
          end        
        end
      end  
    end
    function [obj] = inverse(self)
      %% Calculate inverse adjacency relation
      % CAUTION: the inverse function is not idempotence in the sense
      % it does not preserver the ordering of elements, that is
      % ordering(A) is not ordering(inverse(inverse(A)))
      obj = mp.Adjacency();
      if self.isTargetContinuous()
        self.continuousInverse(obj)
      else
        self.discontinuousInverse(obj)
      end
      obj.length = builtin('length', obj.targets);
    end
    function [val] = maxTarget(self)
      val = max(cellfun(@max, self.targets));
    end
    function [val] = maxSource(self)
      if isempty(self.sources)
        val = builtin('length', self.targets);
      else
        val = max(self.sources);
      end
    end
    function [val] = isSourceContinuous(self)
      val = (self.maxSource() == builtin('length', self.sources));
    end
    function [val] = isTargetContinuous(self)
      n = self.maxTarget();
      z = zeros(1, n, 'uint32');
      for i=1:builtin('length', self.targets)
        z(self.targets{i}) = 1;
      end
      val = false;
      if z 
        val = true;
      end
    end
    function [adjlist] = at(self, id)
      if isempty(self.sources)
        adjlist = self.at_continuous(id);
      else
        adjlist = self.at_discontinuous(id);
      end
    end   
    function write(self, fhandle)
      if nargin < 2
        fhandle = 1;
      end
      s = self.getSources();
      n = builtin('length', s);
      fprintf(fhandle, '%d\n', n);
      for i=1:n
        fprintf(fhandle, '%d', s(i));
        fprintf(fhandle, ' %d', self.targets{i});
        fprintf(fhandle, '\n');
      end
    end
    function s = getSources(self)
      if isempty(self.sources)
        s = 1:self.length;
      else
        s = self.sources;
      end
    end
  end
  
  methods (Access=private)
    function set_at(self, id, adjList)
      n = size(self.targets,1);
      self.targets{n+1} = adjList;
      if isempty(self.sources)
        if id > n+1
          self.sources = uint32([1:n, id]);
        end
      end
    end
    function [adjlist]=at_discontinuous(self, id)
      k = find(self.sources == id);
      if builtin('length',k) > 1
        error('Adjacency corrupted, source list not unique. Duplicated entries %d', k);
      end
      adjlist = self.targets{k};
    end
    function [adjlist]=at_continuous(self, id)
      adjlist = self.targets{id};
    end
    function allocateTargets(self, n)
      self.targets = cell(1, n);
    end
    function continuousInverse(self, inverse)
      n = self.maxTarget();
      inverse.allocateTargets(n);
      s = self.getSources();
      for i=1:builtin('length',s)
        for k = self.targets{i}
          inverse.targets{k} = uint32([inverse.targets{k}, s(i)]);
        end
      end
    end
    function discontinuousInverse(self, inverse)
      persistent tag
      persistent untag
      if isempty(tag)
        tag = @(k) sprintf('t%d',k);
      end
      if isempty(untag)
        untag = @(t) uint32(str2double(t(2:end)));
      end
      map = struct();
      s = self.getSources();
      for i=1:builting('length',s)
        adjList = self.targets{i};
        for t = adjList
          ts = tag(t);
          if isfield(map, ts)
             map.(ts) = uint32([map.(ts), s(i)]);
           else
             map.(ts) = uint32(s(i));
           end   
        end
      end
      fn = fieldnames(map);
      inverse.sources = cellfun(@(z) untag(z), fn);
      inverse.targets = cellfun(@(z) map.(z),  fn, 'UniformOutput', false);
    end
  end
end

