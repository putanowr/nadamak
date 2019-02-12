function [p,T] = simple_triangle_mesh(n,p)
% input arguments
% the number of refinements n < 8 (larger may be very slow)
% p the coordinates of the points as a 3x2 matrix
% outputs 
% the vertices of the triangles p: a m x 2 matrix
% the triangle matrix: each line represents the indexes of the respective triangle
if nargin < 2
p = [-1 0;
      1 0;
      0 sqrt(3)];
end
 
T = [1 2 3];
 
ap = size(p,1);
for i = 1:n
ct = size(T,1);
T1 = [];
E = [];
for j = 1:ct;
Tr = p(T(j,:),:);
p1 = Tr(1,:);
p2 = Tr(2,:);
p3 = Tr(3,:);
 
n1 = (p2+p3)/2;
n2 = (p1+p3)/2;
n3 = (p1+p2)/2;
 
t1 = [ap+1 ap+2 ap+3];
t2 = [T(j,1) ap+2 ap+3];
t3 = [T(j,2) ap+1 ap+3];
t4 = [T(j,3) ap+1 ap+2];
T1 = [T1; t1;t2;t3;t4];
p = [p; n1;n2;n3];
 
ap = ap+3;
end
T = T1;
dx = norm(n1-n2);
[pt,I,J] = unique(p,'rows');
p = p(I,:);
ap = size(p,1);
T(:,1:3) = J(T(:,1:3));
end ;
