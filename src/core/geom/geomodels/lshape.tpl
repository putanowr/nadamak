lc = <lc>;
w = <dW>;
h = <dH>;
r = <dr>;
t = <dt>;
quadsonly = <quadsonly>;
lcFactors[] = {<lcFactors>};

If (quadsonly != 0) 
Mesh.RecombinationAlgorithm = 1;
Mesh.RecombineAll = 1;
EndIf

xam = 1-Cos(Pi/4);
yam = 1-Sin(Pi/4);

Point(1)  = {0  , 0,   0, lcFactors(0)*lc};
Point(2)  = {w  , 0,   0, lcFactors(1)*lc};
Point(3)  = {w  , t-r, 0, lcFactors(2)*lc};
Point(4)  = {w-r*xam, t-r*yam, 0, lcFactors(3)*lc};
Point(5)  = {w-r, t,   0, lcFactors(4)*lc};
Point(6)  = {t+r, t,   0, lcFactors(5)*lc};
Point(7)  = {t+r*xam,  t+r*yam, 0, lcFactors(6)*lc};
Point(8)  = {t  , t+r, 0, lcFactors(7)*lc};
Point(9)  = {t  , h-r, 0, lcFactors(8)*lc};
Point(10) = {t-r*xam, h-r*yam, 0, lcFactors(9)*lc};
Point(11) = {t-r, h,   0, lcFactors(10)*lc};
Point(12) = {0  , h,   0, lcFactors(11)*lc};
Point(13) = {w-r, t-r, 0, lc}; // center
Point(14) = {t+r, t+r, 0, lc}; // center
Point(15) = {t-r, h-r, 0, lc}; // center
Line(1) = {1,2};
Line(2) = {2,3};
Circle(3) = {3,13,4};
Circle(4) = {4,13,5};
Line(5) = {5,6};
Circle(6) = {6,14,7};
Circle(7) = {7,14,8};
Line(8) = {8,9};
Circle(9) = {9,15,10};
Circle(10) = {10,15,11};
Line(11) = {11,12};
Line(12) = {12,1};
Line Loop(1) = {1,2,3,4,5,6,7,8,9,10,11,12};
Plane Surface(1) = {1} ;
Physical Surface("domain") = {1} ;
Physical Line("boundary") = {1,2,3,4,5,6,7,8,9,10,11,12};
Physical Line("bottom") = {1};
Physical Line("left") = {12};
Physical Line("other") = {2,3,4,5,6,7,8,9,10,11};
