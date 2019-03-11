lc = <lc>;
w = <dW>;
r = <dr>;
quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

Point(1)  = {-w, -w, 0, lcFactors(0)*lc};
Point(2)  = { w, -w, 0, lcFactors(1)*lc};
Point(3)  = { w,  w, 0, lcFactors(2)*lc};
Point(4)  = {-w,  w, 0, lcFactors(3)*lc};
Point(5)  = {-r, -r, 0, lcFactors(4)*lc};
Point(6)  = { r, -r, 0, lcFactors(5)*lc};
Point(7)  = { r,  r, 0, lcFactors(6)*lc};
Point(8)  = {-r,  r, 0, lcFactors(7)*lc};
Point(9)  = {0, 0, 0, lc};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Circle(5) = {5,9,6};
Circle(6) = {6,9,7};
Circle(7) = {7,9,8};
Circle(8) = {8,9,5};
Line Loop(1) = {1,2,3,4};
Line Loop(2) = {5,6,7,8};
Plane Surface(1) = {1,2};
Physical Surface("d_domain") = {1};
Physical Line("b_outer_s") = {1};
Physical Line("b_outer_e") = {2};
Physical Line("b_outer_n") = {3};
Physical Line("b_outer_w") = {4};
Physical Line("b_inner") = {5,6,7,8};
