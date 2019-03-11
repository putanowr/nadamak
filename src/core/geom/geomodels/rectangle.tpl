lc = <lc>;
quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};
trans = <transfinite>;
transres[] = {<transres>};

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

Point(1) = {<pt1>, lcFactors(0)*lc};
Point(2) = {<pt2>, lcFactors(1)*lc};
Point(3) = {<pt3>, lcFactors(2)*lc};
Point(4) = {<pt4>, lcFactors(3)*lc};
Line(1) = {1,2} ;
Line(2) = {3,2} ;
Line(3) = {3,4} ;
Line(4) = {4,1} ;
Line Loop(1) = {4,1,-2,3} ;
Plane Surface(1) = {1} ;
Physical Point("p_corners") = {1,2,3,4};
Physical Line("b_south") = {1};
Physical Line("b_east") = {2};
Physical Line("b_north") = {3};
Physical Line("b_west") = {4};
Physical Surface("d_domain") = {1} ;

If (trans != 0)
Transfinite Curve{1,3} = transres(0);
Transfinite Curve{2,4} = transres(1);
Transfinite Surface{1};
EndIf
