mp_test_register('Mesh_formats', 'Testing Mesh I/O formats info')

for format = {'msh'}'
  msg = sprintf('Failed to see format: "%s"', format{:});
  status = contains(mp.Mesh.readFormats, format);
  mp_test_assert(status, msg); 
  status = contains(mp.Mesh.writeFormats, format);
  mp_test_assert(status, msg);
end
