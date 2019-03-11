function result = mp_manage_demos(varargin)
  persistent demos_registry

  if isempty(demos_registry)
    demos_registry=struct();
  end

  command = varargin{1};
  if nargin == 2
    name = varargin{2};
    if  strcmp(command, 'register')
      demos_registry.(name) = struct('status',false,'timer',tic(),'enlapsed',0);
    elseif strcmp(command, 'cleanup')
      if demos_registry.(name).status == false    
        demos_registry.(name).enlapsed = 0;
      end
    else
      error('Invalid demo management command: %s', command)
    end
  elseif nargin == 3
    if strcmp(command, 'report')
      demoname=varargin{2};
      demos_registry.(demoname).status = varargin{3};
      demos_registry.(demoname).enlapsed = toc(demos_registry.(demoname).timer);
    else
      error('Invalid demo management command: %s', command)
    end
  elseif nargin == 1
    if strcmp(command, 'status')
      result = true;
      demonames  = fieldnames(demos_registry);
      for i = 1:length(demonames)
        name = demonames{i};
        result = result && demos_registry.(name).status;
      end
    elseif strcmp(command, 'print')
      stamp = replace(datestr(now),{' ', '-', ':'}, {'_'});
      fname = ['demos_timing_', stamp, '.txt'];
      sep = filesep();
      [status, msg, msgid] = mkdir('log');
      if ~status 
        error(msg);
      end
      fname = strcat('.', sep, 'log', sep, fname);
      fhandle = fopen(fname, 'w');
      if fhandle == -1
	error('Cannot open filename for writing timestamp: %s', fname);
      end
      demonames  = fieldnames(demos_registry);
      for i = 1:length(demonames)
        name = demonames{i};
        fprintf('demo %40s | %1d | %8.2f\n', name, demos_registry.(name).status, ...
                demos_registry.(name).enlapsed);
        fprintf(fhandle, 'demo %40s | %1d | %8.2f\n', name, demos_registry.(name).status, ...
                demos_registry.(name).enlapsed);
      end
      fclose(fhandle);
    end   
  end 
end
