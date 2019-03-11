function mp_log(format, varargin)
% MP_LOG - writ log message to standard output indenting it according to
% value of mp_LOG_INDENT.
  global mp_LOGGING
  global mp_LOG_INDENT
  if mp_LOGGING 
      msg = sprintf(format, varargin{:});
      msg = strrep(msg, '\', '\\');
      s = sprintf('\n%*s%s\n', 5+mp_LOG_INDENT, 'LOG: ', msg);
      fprintf(s);
  end
end

