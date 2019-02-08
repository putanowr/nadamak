lc = <lc>;
dW = <dW>;
dH = <dH>;
dmx = <dmx>;
dmy = <dmy>;
dbottom = <dbottom>;
dtop = <dtop>;
curved = <curved>;
structured[] = {<structured>};
quadsonly = <quadsonly>;
quads[] = {<quads>};
nxelems[] = {<nxelems>};
nyelems = <nyelems>;
insets[] = {<insets>};
insets_x[] = {<insets_x>};
insets_y[] = {<insets_y>};
insets_R[] = {<insets_R>};
insets_N[] = {<insets_N>};

Mesh.RecombinationAlgorithm = 1;
If (quadsonly != 0) 
Mesh.RecombineAll = 1;
EndIf

Macro CircularInset
  _x = CircularInset_x;
  _y = CircularInset_y;
  _R = CircularInset_R;
  _N = CircularInset_N;
  If ( Exists(CircularInset_lc) )
    _lc = CircularInset_lc;
  Else
    _lc = 1.0;
  EndIf
  _cip = newp; // Cener point
  _da = 2*Pi/_N;
  Point(_cip) = {_x, _y, 0, _lc};
  _sp = newp; // Start point of circle;
  Point(_sp) = {_x+_R, _y, 0, _lc};
  For _i In {1:_N-1}
    Rotate {{0,0,1}, {_x, _y, 0}, _i*_da} { Duplicata {Point {_sp}; } }
  EndFor
  _nl = newl;
  _arcs[] = {};
  For _i In {0:_N-1}
    _sbegin = _sp + _i;
    _send = _sp + (_i+1) % _N;
    Circle(newl) = {_sbegin, _cip, _send};
    _arcs[] = {_arcs[], -(_nl+_i)};
  EndFor  
  _c1b = newll;
  CircularInset_boundary = _c1b;
  Line Loop(_c1b) = {_arcs[]};
Return

Point(1) = {  0,     0, 0, lc};
Point(2) = {dbottom, 0, 0, lc};
Point(3) = {dW,      0, 0, lc};
Point(4) = {dW,     dH, 0, lc};
Point(5) = {dtop,   dH, 0, lc};
Point(6) = {  0,    dH, 0, lc};
Point(7) = {dmx,   dmy, 0, lc};
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

For i In {1:2}
  If (insets[i-1] != 0)
    CircularInset_x = insets_x[i-1];
    CircularInset_y = insets_y[i-1];
    CircularInset_R = insets_R[i-1];
    CircularInset_N = insets_N[i-1];
    CircularInset_lc = lc;
    Call CircularInset;
    Plane Surface(i) = {i, CircularInset_boundary};
  Else
    Plane Surface(i) = {i};
  EndIf
EndFor

If (curved == 1) 
  If (insets[0] == 0 && structured[0] == 1)
    Transfinite Line {1, 5} = nxelems[0]+1; // +1 because it's num of nodes
    Transfinite Line {7, 6} = nyelems+1; // +1 because it's num of nodes
    Transfinite Surface {1};
  EndIf

  If (insets[1] == 0 && structured[1] == 1)
    Transfinite Line {2, 4} = nxelems[1]+1; // +1 because it's num of nodes
    Transfinite Line {3, 7} = nyelems+1; // +1 bacause it's num of nodes
    Transfinite Surface {2};
  EndIf
EndIf

If (quads[0]) 
  Recombine Surface {1};
EndIf

If (quads[1])
  Recombine Surface {2};
EndIf

Physical Surface("domain") = {1,2};
Physical Point("corners") = {1,2,3,4,5,6};
Physical Line("boundary") = {5,6,1,2,3,4};
Physical Line("left_boundary") = {5,6,1};
Physical Line("right_boundary") = {2,3,4};
Physical Surface("left") = {1};
Physical Surface("rigth") = {2};
