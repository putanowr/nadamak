lc = <lc>;
lcFactors[] = {<lcFactors>}; // array of 14 values
w = <dW>;
h = <dH>;
r = <dr>;
t = <dt>;
// Factors for placement of interface endpoints.
// The factor value should be in range <0, 1>.
fA = <fA>;
fB = <fB>;
meshall = <meshall>;

quadsonly = <quadsonly>;
// Vector of size 2 with values 0 or 1 for meshing surface with quads.
quads[] = {<quads>};

Mesh.RecombinationAlgorithm = 1;
If (quadsonly != 0) 
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
Point(7)  = {t+r*xam, t+r*yam, 0, lcFactors(6)*lc};
Point(8)  = {t  , t+r, 0, lcFactors(7)*lc};
Point(9)  = {t  , h-r, 0, lcFactors(8)*lc};
Point(10) = {t-r*xam, h-r*yam, 0, lcFactors(9)*lc};
Point(11) = {t-r, h,   0, lcFactors(10)*lc};
Point(12) = {0  , h,    0, lcFactors(11)*lc};

// Points that create interface line
Point(13) = {0,   fA*h, 0, lcFactors(12)*lc};
Point(14) = {t,   (1-fB)*(t+r)+fB*(h-r), 0, lcFactors(13)*lc};

Point(15) = {w-r, t-r, 0, lc}; // center
Point(16) = {t+r, t+r, 0, lc}; // center
Point(17) = {t-r, h-r, 0, lc}; // center
  
Line(1) = {1,2};
Line(2) = {2,3};
Circle(3) = {3,15,4};
Circle(4) = {4,15,5};
Line(5) = {5,6};
Circle(6) = {6,16,7};
Circle(7) = {7,16,8};
Line(8) = {8,14};
Line(9) = {14,9};
Circle(10) = {9,17,10};
Circle(11) = {10,17,11};
Line(12) = {11,12};
Line(13) = {12,13};
Line(14) = {13, 1};
// Interface line
Line(15) = {13, 14};

Line Loop(1) = {1,2,3,4,5,6,7,8,-15, 14};
Line Loop(2) = {9,10,11,12,13,15};

Plane Surface(1) = {1};
Plane Surface(2) = {2};

If (quads[0]) 
  Recombine Surface {1};
EndIf

If (quads[1])
  Recombine Surface {2};
EndIf

regionName="";
regionDef[]={};

Macro AddRegionLine
  If (StrFind(Str("<regionsToMesh>"), regionName ) > 0 || meshall!=0) 
    Physical Line(Str(regionName)) = regionDef[];
  EndIf
Return

Macro AddRegionSurface
  If (StrFind(Str("<regionsToMesh>"), regionName ) > 0 || meshall!=0) 
    Physical Surface(Str(regionName)) = regionDef[];
  EndIf
Return

regionDef[] = {1};
regionName = "d_subBottom";
Call AddRegionSurface;

regionDef[] = {2};
regionName = "d_subTop";
Call AddRegionSurface;

regionDef[] = {1};
regionName = "b_bottom";
Call AddRegionLine;

regionDef[] = {13};
regionName = "b_left_top";
Call AddRegionLine;

regionDef[] = {14};
regionName = "b_left_bottom";
Call AddRegionLine;

regionDef[] = {2,3,4,5,6,7,8};
regionName = "b_other_bottom";
Call AddRegionLine;

regionDef[] = {9,10,11,12};
regionName = "b_other_top";
Call AddRegionLine;

regionDef[] = {15};
regionName = "i_interface";
Call AddRegionLine;

