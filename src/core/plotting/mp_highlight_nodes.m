%% Highlight selected nodes.
%  Arguments: 
%   * graphicsHandle - handle to nodes objec as returned by mp_plot_nodes()
%                      or mp_plot_mesh()
%   * nodeNumber - nodes to be highlighted
function mp_highlight_nodes(graphicsHandle, nodeNumbers, colorOrOptions)
  if nargin < 3
    hcolor = 'red';
  else
    hcolor = mp_get_option(colorOrOptions, 'markerColor', 'red');
  end
  
  npt = length(get(graphicsHandle, 'XData'));
  
  sizeData = get(graphicsHandle, 'SizeData');
  if isstruct(colorOrOptions)
    if isfield(colorOrOptions, 'markerSize')
      if length(sizeData) < 2
        sizeData = ones(1,npt)*sizeData;
      end
      sizeData(nodeNumbers) = colorOrOptions.('markerSize');
    end
    if isfield(colorOrOptions, 'markerFactor')
      markerFactor = colorOrOptions.('markerFactor');
      if (length(sizeData) < 2) 
        sizeData = sizeData*ones(1, npt);
      end
      sizeData(nodeNumbers) = sizeData(nodeNumbers)*markerFactor;
    end
  end
 
  rbgColor = rgb(hcolor);

  cdata = get(graphicsHandle, 'cdata');
  s = size(cdata);
  
  if s(1) == 1 && s(2) == 3
    cdata = repmat(cdata, npt, 1);
  elseif s(2) == 1
    cmap = colormap();
    cdata = cmap(cdata,:);
  end   
  n = length(nodeNumbers); 
  cdata(nodeNumbers,:)=repmat(rbgColor, n, 1);
  set(graphicsHandle, 'cdata', cdata, 'SizeData', sizeData);
end
