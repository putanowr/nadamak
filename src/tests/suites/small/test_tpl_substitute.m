mp_test_register('tpl_substitute', 'template substitutions')
template = 'Foo <foo> bar <bar> <foo>';
context.foo = 12;
context.bar = [1,3];
actualResult = mp_tpl_substitute(template, context);
expectedResult = 'Foo 12 bar 1,3 12';
mp_test_assert_equal(expectedResult, actualResult)