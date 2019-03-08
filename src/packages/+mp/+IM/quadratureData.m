function [pts, w] = quadratureData(tag)
% return data for quadratures: quadrature points and weights.
  persistent qd
  if isempty(qd)
    for npts = [1,2,3,4,5,6]
      order = 2*npts-1;
      tag = sprintf('Gauss1D_%d', order);
      [p, w] = legpts(npts, [0.0, 1.0]);
      pts = zeros(npts, 3);
      pts(:,1) = p';
      qd.(tag).pts = pts;
      qd.(tag).w = w
    end
    qd.Triangle_1.pts = [1/3, 1/3, 0]
    qd.Triangle_1.w = [1/2]
    qd.Triangle_2.pts = [1/6, 1/6, 0;
                         2/3, 1/6, 0;
			 1/6, 2/3, 0];
    qd.Triangle_2.w = 1/6*[1,1,1];
    qd.Triangle_3.pts = [1/3, 1/3, 0;
                         1/5, 1/5, 0;
			 3/5, 1/5, 0;
			 1/5, 3/5, 0];
    qd.Triangle_3.w = [-27, 25, 25, 25]/96;
    a = 0.445948490915965;
    b = 0.091576213509771;
    c = 0.111690794839005;
    d = 0.054975871827661;
    qd.Triangle_4.pts = [a,a,0;
                         1-2*a, a, 0;
			 a, 1-2*a, 0;
			 b, b, 0;
			 1-2*b, b, 0;
			 b, 1-2*b, 0];
    qd.Triangle_4.w = [c,c,c,d,d,d];
  end
  pts = qd.(tag).pts;
  w = qd.(tag).w;
end
