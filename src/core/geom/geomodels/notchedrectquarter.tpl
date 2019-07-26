singlesurf = <singlesurf>;
quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};
trans = <transfinite>;
transres[] = {<transres>};

If (quadsonly != 0)
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

lc = <lc>;
R = <dR>;
W = <dW>;
H = <dH>;
t = <amid>;

xa = W-R*Cos(t*Pi/2);
ya = R*Sin(t*Pi/2);
Point(1) = {0,     0, 0, lc*lcFactors[0]};
Point(2) = {W-R,   0, 0, lc*lcFactors[1]};
Point(3) = {xa,   ya, 0, lc*lcFactors[2]};
Point(4) = {W,     R, 0, lc*lcFactors[3]};
Point(5) = {W,     H, 0, lc*lcFactors[4]};
Point(6) = {0,     H, 0, lc*lcFactors[5]};
Point(7) = {W, 0, 0};
Line(1) = {1,2} ;
Circle(2) = {2,7,3};
Circle(3) = {3,7,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,1};
Line(7) = {6,3};
Line Loop(1) = {1, 2, -7, 6};
Line Loop(2) = {3, 4, 5, 7};
Plane Surface(1) = {1};
Plane Surface(2) = {2};

If (singlesurf != 0)
  Compound Surface {1,2};
EndIf

If (trans != 0)
Transfinite Curve{1,4,7} = transres(0);
Transfinite Curve{3,5} = transres(1);
Transfinite Curve{2,6} = transres(2);
Transfinite Surface{1};
Transfinite Surface{2};
EndIf

Physical Point("p_sw") = {1};
Physical Point("p_arc_start") = {2};
Physical Point("p_arc_mid") = {3};
Physical Point("p_arc_end") = {4};
Physical Point("p_ne") = {5};
Physical Point("p_nw") = {6};
Physical Curve("b_south") = {1};
Physical Curve("b_arc_s") = {2};
Physical Curve("b_arc_n") = {3};
Physical Curve("b_east") = {4};
Physical Curve("b_north") = {5};
Physical Curve("b_west") = {6};

If (singlesurf != 0)
  Physical Surface("d_domain") = {1,2};
Else
  Physical Curve("i_interface") = {7};
  Physical Surface("d_bottom") = {1};
  Physical Surface("d_top") = {2};
EndIf

