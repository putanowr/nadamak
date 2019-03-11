function mp_run_single_demo(demoName)
  sep = filesep();
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  nadamak_environ();
  
  scriptName = ['demo_', demoName];
  
  mp_manage_demos('register', demoName);
  run(scriptName);
  end
