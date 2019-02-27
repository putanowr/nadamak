lc = <lc>;
quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

Point(1) = {<pt1>, lcFactors(0)*lc};
Point(2) = {<pt2>, lcFactors(1)*lc};
Point(3) = {<pt3>, lcFactors(2)*lc};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,1};
Line Loop(1) = {1,2,3} ;
Plane Surface(1) = {1} ;
Physical Point("p_corners") = {1,2,3};
Physical Line("b_AB") = {1};
Physical Line("b_BC") = {2};
Physical Line("b_CA") = {3};
Physical Surface("d_domain") = {1} ;