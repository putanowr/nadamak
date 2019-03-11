function mp_demo_to_pdf(demoName)
  sep = filesep();
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  mp_test_set_environ();
  
  scriptName = ['demo_', demoName];
  
  mp_manage_demos('register', demoName);
  publish(scriptName, 'pdf');
  end
