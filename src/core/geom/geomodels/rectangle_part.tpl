_np = newp;
Point(_np) = {<pt1>, <lc>};
Point(newp) = {<pt2>, <lc>} ;
Point(newp) = {<pt3>, <lc>} ;
Point(newp) = {<pt4>, <lc>} ;
_nl = newl;
Line(_nl) = {_np,_np+1} ;
Line(newl) = {_np+2,_np+1} ;
Line(newl) = {_np+2,_np+3} ;
Line(newl) = {_np+3,_np} ;
_nll = newll;
Line Loop(_nll) = {_nl+3,_nl,-(_nl+1),_nl+2};
Physical Point("<partname>_corners") = {_np,_np+1,_np+2, _np+3};
Physical Line("<partname>_south") = {_nl};
Physical Line("<partname>_east") = {_nl+1};
Physical Line("<partname>_north") = {_nl+2};
Physical Line("<partname>_west") = {_nl+3};
Physical Line("<partname>") = {_nl, _nl+1, _nl+2, _nl+3};