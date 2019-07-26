classdef ParamFactory < handle
  methods(Static)
    function [pval] = produce(paramtype, params)
      pt = mp.ParamType(paramtype);
      [fid, fromfile, needclose] = whereToGetData(params);
      if fromfile
        datasize = fscanf(fid, '%d', [1,2]);
        data = fscanf(fid, '%f', datasize);
        data = data';
        if needclose
          fclose(fid);
        end
      else
        data = mp_get_option(params, 'value', nan);
        if ischar(data)
          data = mp_parse_array(data);
        end
      end
      if ismissing(data)
        error('Missing value for param %s', char(paramtype));
      end
      pval = makeParamVal(pt, data);
    end
  end
end
function [fid, fromfile, needclose] = whereToGetData(params)
  fromfile=false;
  needclose = false;
  fid = -1;
  if isfield(params, 'fid')
    fid = params.fid;
    fromfile=true;
  elseif isfield(params, 'path')
    fid = fopen(params.path, "r");
    fromfile=true;
    needclose=true;
  end
end
function [pval] = makeParamVal(pt, data)
  datasize = size(data);
  switch(pt)
    case mp.ParamType.Const
      if datasize(1) ~= 1
        error('Invalid data for ParamConstVal size=%d > 1', datasize(1));
      end
      pval = mp.ParamConstVal(data);
    case mp.ParamType.Poly
      if datasize(2) < 2 || datasize(1) < 2
        error('Invalid data for ParamPolyVal size=[%d,%d]', datasize(1),...
                  datasize(2));
      end
      pval = mp.ParamPolyVal(data(:,1), data(:,2:end));
    otherwise
      error('Unsupported parameter type %d', char(pt));
  end
end


