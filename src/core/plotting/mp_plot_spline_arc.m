function [handles] = mp_plot_spline_arc(startPoint, endPoint, chordFactor, npoints, narrows);
  if nargin < 5;
    narrows = 3;
  end
  if nargin < 4
    npoints = 6;
  end
  if nargin < 3
    chordFactor = 0.1;
  end
  dirVec = (endPoint - startPoint);
  midPoint = 0.5*(endPoint+startPoint);
  tanVec = dirVec;
  tanVec(1:2) = [-tanVec(2); tanVec(1)];
  arcPoint = midPoint+0.5*chordFactor*tanVec;
  ctrPts = [startPoint; arcPoint; endPoint]';
  t = linspace(0,1,3);
  pp = csape(t, ctrPts);
  xy = ppval(pp, linspace(0,1, npoints));
  handles.lines = line(xy(1,:), xy(2,:));
  color = get(handles.lines, 'Color');
  if narrows >= npoints
    narrows = npoints-1;
  end
  n = round(linspace(1, npoints-1, narrows));
  vec = diff(xy, 1, 2);
  handles.arrows=quiver(xy(1,n)', xy(2,n)', vec(1,n)', vec(2, n)', 0, 'Color', color);
end
