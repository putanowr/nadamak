function [pts] = mp_triangle_rand_points(vertices, npts)
% Return set random points uniformly distributed in a triangle.
% 
  r = rand(npts, 2);
  rs = sqrt(r(:,1));
  pts =          (1-rs)*vertices(1,:) + ...
       (rs.*(1-r(:,2)))*vertices(2,:) + ...
	   (rs.*r(:,2))*vertices(3,:);
end
