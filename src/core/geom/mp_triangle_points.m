function [pts] = mp_triangle_points(vertices, nx, ny, perm)
% Return set of points in triangle obtained by transformin
% 
  if nargin < 4
    perm = [3,1,2];
  end
  if nargin < 3
    ny = nx;
  end
  x = linspace(0,1,nx);
  y = linspace(0,1,ny);
  [xx,yy] = meshgrid(x,y);
  n = prod(size(xx));
  bary = [];
  for i=1:n
    if xx(i) <= 1-yy(i);
      bary = [bary; xx(i),yy(i), 1-xx(i)-yy(i)];
   end
  end
  bary = bary(:,perm);
  npts = size(bary,1);
  pts = zeros(npts,2);
  for i=1:npts
    pts(i, :) = mp_bary2cart2D(vertices(), bary(i, :));
  end
end
