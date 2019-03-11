%% Extract element type from element record
%  Arguments:
%    elrecord - vector of integer values as generated by GMSH.
function [eltype] = mp_gmsh_element_type(elrecord)
  eltype = elrecord(2);
end