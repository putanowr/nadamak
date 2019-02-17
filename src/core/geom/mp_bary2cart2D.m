function [xy] = mp_cart2bary2D(pts, bary)
% For triangle with vertex coordinates pt and cartesian coordinates xy
% find correcponding barycentric coordinates. 
% Arguments: pts is a matrix (3 by 2) and bary is a vector (1 by 3);
% Returns: vector (1 by 2)
  T = ones(3,3);
  T(1,:) = pts(:,1)';
  T(2,:) = pts(:,2)';
  xya = T*bary';
  xy = xya(1:2)';
end
