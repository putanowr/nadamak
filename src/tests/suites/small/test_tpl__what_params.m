mp_test_register('tpl_what_params', 'extract_template_parameters')
template = 'Foo <foo> bar <bar> <foo>';
context = mp_tpl_what_params(template);
mp_test_assert_equal(2, length(fieldnames(context)))