// Gmsh project created on Mon Jan 07 23:40:59 2019
//+
lc = <lc>;
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {0, 20, 0, lc};
//+
Point(3) = {20, 0, 0, lc};
//+
Point(4) = {20, 4, 0, lc};
//+
Point(5) = {10, 5, 0, lc};
//+
Point(6) = {5, 20, 0, lc};
//+
Point(7) = {-1, 5, 0, lc};
//+
Point(8) = {-9, 5, 0, lc};
//+
Point(9) = {-9, 0, 0, lc};
//+
Line(1) = {9, 3};
//+
Line(2) = {3, 4};
//+
Line(3) = {4, 5};
//+
Line(4) = {5, 6};
//+
Line(5) = {6, 2};
//+
Line(6) = {2, 7};
//+
Line(7) = {7, 7};
//+
Line(8) = {7, 8};
//+
Line(9) = {8, 9};
//+
Curve Loop(1) = {3, 4, 5, 6, 8, 9, 1, 2};
//+
Plane Surface(1) = {1};
//+
out[] = Extrude {{0, 1, 0}, {-20, 0, 0}, Pi/4} {
  Surface{1}; 
};
Physical Surface("base") = {out[]};
