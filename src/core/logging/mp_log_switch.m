function status = mp_log_switch()
  global mp_LOGGING
  mp_LOGGING = ~mp_LOGGING;
  status = mp_LOGGING;
end

