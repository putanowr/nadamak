function [val] = mp_get_legacy_data(globalModel, name)
%% Extract named legacy data from globalModel object
  if strcmp('obszar', name)
    val = globalModel.geometry.legacyID;
    return
  elseif strcmp('wymiar', name)
    val = globalModel.geometry.dim;
    return
  else 
    error('Not supported legacy data name: %s', name)
  end
end
