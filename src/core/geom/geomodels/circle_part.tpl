_np = newp;
Point(_np) = {<x>, <y>, 0.0, <lc>};
Point(newp) = {<x>+<R>, <y>, 0.0, <lc>};
Point(newp) = {<x>, <y>+<R>, 0.0, <lc>};
Point(newp) = {<x>-<R>, <y>, 0.0, <lc>};
Point(newp) = {<x>, <y>-<R>, 0.0, <lc>};
_nl = newl;
Circle(_nl) = {_np+1, _np, _np+2} ;
Circle(newl) = {_np+2, _np, _np+3} ;
Circle(newl) = {_np+3, _np, _np+4} ;
Circle(newl) = {_np+4, _np, _np+1} ;
_nll = newll;
Line Loop(_nll) = {_nl, _nl+1, _nl+2, _nl+3};
Physical Line("<partname>") = {_nl, _nl+1, _nl+2, _nl+3};
