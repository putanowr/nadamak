function [model] = mp_build_model(project)
  geometry = mp_geom_factory(project.geometry.name);
  problem = mp_problem_factory(project.problem.name); 
  model = mp.FemModel(geometry, problem);
end
