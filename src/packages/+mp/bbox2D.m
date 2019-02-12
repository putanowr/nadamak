function [bbox] = bbox2D(points)
  % Calculate 2D box.
  xmin = min(points(:,1));
  xmax = max(points(:,1));
  ymin = min(points(:,2));
  ymax = max(points(:,2));
  bbox = [xmin, xmax, ymin, ymax];
end
