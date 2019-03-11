%% Writes exception report to give fid
function mp_test_report_exception(fid, exception)
  if mp_is_octave()
    for frame = exception.stack
      fprintf(fid, '    where: %s\n', frame.name)
    end
  else
    fprintf(fid, '%s\n', getReport(exception))
  end 
end
