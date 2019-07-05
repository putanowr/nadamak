quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};
trans = <transfinite>;
transres[] = {<transres>};

lc = <lc>;
H = <dH>;
W = <dW>;

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

Point(1) = {  0,       0, 0, lc*lcFactors[0]};
Point(2) = {  W/2,     0, 0, lc*lcFactors[1]};
Point(3) = {  W,       0, 0, lc*lcFactors[2]};
Point(4) = {  W,       H, 0, lc*lcFactors[3]};
Point(5) = {  W/2,     H, 0, lc*lcFactors[4]};
Point(6) = {  0,       H, 0, lc*lcFactors[5]};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,1};
Line(7) = {2,5};
Line Loop(1) = {1, 7, 5, 6};
Line Loop(2) = {2, 3, 4, -7};
Plane Surface(1) = {1};
Plane Surface(2) = {2};

If (trans != 0)
Transfinite Curve{1,2,4,5} = transres(0);
Transfinite Curve{3,6,7} = transres(1);
Transfinite Surface{1};
Transfinite Surface{2};
EndIf

Physical Point("p_sw") = {1};
Physical Point("p_se") = {3};
Physical Point("p_ne") = {4};
Physical Point("p_nw") = {6};
Physical Point("p_sm") = {2};
Physical Point("p_nm") = {5};
Physical Line("b_left_south") = {1};
Physical Line("b_right_south") = {2};
Physical Line("b_east") = {3};
Physical Line("b_left_north") = {4};
Physical Line("b_right_north") = {5};
Physical Line("b_west") = {6};
Physical Line("i_interface") = {7};
Physical Surface("d_left") = {1};
Physical Surface("d_rigth") = {2};
