function [problem] = mp_problem_factory(name)
  %% Create GeomModel from a name
  persistent registeredProblems
  if isempty(registeredProblems)
  end  
  if nargin < 1
    geomModel = fieldnames(registeredProblems);
    return
  end
  problem = mp.Problem();
end
