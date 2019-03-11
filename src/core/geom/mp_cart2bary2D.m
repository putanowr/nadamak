function [bary] = mp_cart2bary2D(pts, xy)
% For triangle with vertex coordinates pt and cartesian coordinates xy
% find correcponding barycentric coordinates. 
% Arguments: pts is a matrix (3 by 2) and xy is a vector (1 by 2);
% Returns: vector (1 by 3)
  T = ones(3,3);
  T(1,:) = pts(:,1)';
  T(2,:) = pts(:,2)';
  bary = T\[xy,1]';
end
