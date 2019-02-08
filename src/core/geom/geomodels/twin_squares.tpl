lc = <lc>;
w = <w>;
a = <a>;
curved = <curved>;
quadsonly = <quadsonly>;

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

Point(1) = {  0,     0, 0, lc};
Point(2) = {  w,     0, 0, lc};
Point(3) = {2*w,     0, 0, lc};
Point(4) = {2*w,     w, 0, lc};
Point(5) = {  w,     w, 0, lc};
Point(6) = {  0,     w, 0, lc};
Point(7) = {a*w, 0.5*w, 0, lc};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,1};
If (curved != 0)
 Spline(7) = {2, 7, 5};
 Line Loop(1) = {1, 7, 5, 6};
 Line Loop(2) = {2, 3, 4, -7};
 Physical Line("interface") = {7};
Else
 Line(7) = {2,7};
 Line(8) = {7,5};
 Line Loop(1) = {1, 7, 8, 5, 6};
 Line Loop(2) = {2, 3, 4, -8, -7};
 Physical Line("interface") = {7,8};
EndIf
Plane Surface(1) = {1};
Plane Surface(2) = {2};
Physical Line("left_boundary") = {5,6,1};
Physical Line("right_boundary") = {2,3,4};
Physical Point("corners") = {1,3,4,6};
Physical Surface("left") = {1};
Physical Surface("rigth") = {2};
