lc = <lc>;
lcFactors[] = {<lcFactors>};
trans = <transfinite>;
transres[] = {<transres>};

Point(1) = {<pt1>, lcFactors(0)*lc};
Point(2) = {<pt2>, lcFactors(1)*lc};
Line(1) = {1,2} ;
Physical Point("p_endpoints") = {1,2};
Physical Line("d_domain") = {1};

If (trans != 0)
Transfinite Curve{1} = transres(0);
EndIf
