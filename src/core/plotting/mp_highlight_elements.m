%% Highlight selected elements.
%  Arguments: 
%   * graphicsHandle - handle to elements object as returned by mp_plot_elements()
%                      or mp_plot_mesh()
%   * elementNumbers - elements to be highlighted
function mp_highlight_elements(graphicsHandle, elementNumbers, colorOrOptions)
  if nargin < 3
    hcolor = 'red';
    lineWidth = 1;
    edgeColor = 'black';
  else
    hcolor = mp_get_option(colorOrOptions, 'elementHiglightColor', 'red');
    edgeColor = mp_get_option(colorOrOptions, 'EdgeColor', 'black');
    lineWidth = mp_get_option(colorOrOptions, 'LineWidth', 1);
  end
  
  elemsId = get(graphicsHandle, 'UserData');
  elems = find(ismember(elemsId, elementNumbers));

  rgbColor = rgb(hcolor);
  
  colors = get(graphicsHandle, 'FaceVertexCData');
  if size(colors, 2) == 1
    cmap = colormap();
    colors = cmap(colors,:);
  end   
  for i = elems
    colors(i, :) = rgbColor;
  end  
  set(graphicsHandle, 'FaceVertexCData', colors);
end
