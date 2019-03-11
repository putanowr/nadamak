%% Highlight selected elements.
%  Arguments: 
%   * graphicsHandle - handle to elements object as returned by mp_plot_elements()
%                      or mp_plot_mesh()
%   * elementNumbers - elements to be highlighted
function mp_highlight_elements(graphicsHandle, elementNumbers, colorOrOptions)
  if nargin < 4
    hcolor = 'red';
  else
    hcolor = mp_get_option(colorOrOptions, 'elementHiglightColor', 'red');
  end
  
  elemsId = get(graphicsHandle, 'UserData');
  
  elems = find(ismember(elemsId, elementNumbers));

  rgbColor = rgb(hcolor);
  
  colors = get(graphicsHandle, 'FaceVertexCData');
  if size(colors, 2) == 1
    cmap = colormap();
    colors = cmap(colors,:);
  end   
  xd = get(graphicsHandle, 'XData');
  yd = get(graphicsHandle, 'YData');
  sf=0.6;
  for i = elems
    colors(i, :) = rgbColor;
    xd(:,i) = sf*xd(:,i) + (1-sf)*mean(xd(:,i));
    yd(:,i) = sf*yd(:,i) + (1-sf)*mean(yd(:,i));
  end  
  set(graphicsHandle, 'FaceVertexCData', colors, 'Vertices', [], 'Faces', [],'XData', xd, 'YData', yd);
  %set(graphicsHandle, 'FaceVertexCData', colors);
end
