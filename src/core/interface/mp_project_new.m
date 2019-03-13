function [project] = mp_project_new(name)
  project.name = name;
  project.geometry = struct('name','');
  project.problem = struct('type', '');
  project.discretisation = struct('ls',1);
end
