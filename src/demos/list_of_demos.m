%% Demos
%
%% Demo execution status
fprintf('Demos executed at: %s\n\n', datestr(now))
mp_manage_demos('print')
%% Interface function demos
% <html>
% <ul>
% <li><a href="demo_mp_get_tagged_nodes.html">demo_mp_get_tagged_nodes</a> Get tagged nodes in regions</li>
% <li><a href="demo_mp_tag_region_nodes.html">demo_mp_tag_region_nodes</a> Show how to tag all nodes</li>
% <li><a href="demo_mp_get_tagged_edges.html">demo_mp_get_tagged_edges</a> Get tagged edges in regions</li>
% <li><a href="demo_mp_face_edge_data_at_regions.html">demo_mp_face_edge_data_at_regions</a> Get normals and tangent vector for element edges and nodes at specified regions.</li>
% <li><a href="demo_mp_face_edge_data.html">demo_mp_face_edge_data</a> illustrate calculation of edge data for faces</li>
% </ul>
% </html>
%
%% Geometric models demos
% <html>
% <ul>
% <li><a href="demo_LShapeGeom.html">demo_LShapeGeom</a> Managing mesh density - example using L-shape geometry</li>
% <li><a href="demo_LShapeGeom_refinement.html">demo_LShapeGeom_refinement</a> Mesh density as function of lc parameter</li>
% <li><a href="demo_LShapeIfaceGeom.html">demo_LShapeIfaceGeom</a> Geometric model with interface (internal boundary)</li>
% <li><a href="demo_LShapeIfaceGeom_queries.html">demo_LShapeIfaceGeom_queries</a> Illustrate queries about interface</li>
% <li><a href="demo_LShapeIfaceGeom_nonconforming.html">demo_LShapeIfaceGeom_nonconforming</a> Non-conforming meshing of sudomains</li>
% <li><a href="demo_LShapeIfaceGeom_normals.html">demo_LShapeIfaceGeom_normals</a>Normals at edges in separate regions</li>
% <li><a href="demo_NotchedRQGeom.html">demo_NotchedRQGeom</a> Geometric doman of quarter of notched rectangle</li>
% <li><a href="demo_SquareHoleGeom.html">demo_SquareHoleGeom</a> Square with circular hole</li>
% <li><a href="demo_TriangleGeom.html">demo_TriangleGeom</a> Triangular domain</li>
% <li><a href="demo_TSHGeom.html">demo_TSHGeom</a> Complex geometry and mesh handing for THS geometry</li>
% </ul>
% </html>
%
%% Mesher demos
% <html>
% <ul>
% <li><a href="demo_Mesher_square.html">demo_Mesher_square</a> use Mesher to generate mesh in a square</li>
% <li><a href="demo_Mesher_globalField.html">demo_Mesher_globalField</a> mesh density control via global size field</li>
% <li><a href="demo_Mesher_refinement.html">demo_Mesher_refinement</a> uniform mesh refinement</li>
% <li><a href="demo_TriangleHighOrder.html">demo_TriangleHighOrder</a> Higher order trianglar elements</li>
% </ul>
% </html>
%% Finite Element Method demos
% <html>
% <ul>
% <li><a href="demo_FEM_FemType.html">demo_FEM_FemType</a> Types of finite elments</li> 
% </ul>
% </html>
%% Object oriented interface demos
% <html>
% <ul>
% <li><a href="demo_mp_enumerations.html">demo_mp_enumerations</a> Show how to use enum values for categorical data</li>
% <li><a href="demo_MeshFactory.html">demo_MeshFactory</a> use MeshFactory and Viewer to show built-in meshes</li>
% <li><a href="demo_mp_elems_centers.html">demo_mp_elems_centers</a> Show how to select elements and access node coordinates</li>
% <li><a href="demo_Mesh_edgeCenters.html">demo_Mesh_edgeCenters</a> Show how to get edge centers for a Mesh</li>
% <li><a href="demo_Mesh_faceCenters.html">demo_Mesh_faceCenters</a> Show how to get face centers for a Mesh</li>
% <li><a href="demo_Mesh_parent_child_submesh.html">demo_Mesh_parent_child_submesh</a> Show mapping from child to parent nodes and elements</li>
% <li><a href="demo_Mesh_submesh.html">demo_Mesh_submesh</a> Show how create submes from regions</li>
% <li><a href="demo_mp_readMesh.html">demo_mp_readMesh</a> Show how to read file into a Mesh object</li>
% <li><a href="demo_mp_view_stars.html">demo_mp_view_stars</a> Calculate and show mesh etities stars</li>
% <li><a href="demo_Viewer.html">demo_Viewer</a> Display geometry</li>
% <li><a href="demo_mp_tagging_nodes.html">demo_mp_tagging_nodes</a> Tag and visualize nodes in regions</li>
% <li><a href="demo_mp_map_circle.html">demo_mp_map_circle</a> Use geometric transformation to map interior of an element</li>
% <li><a href="demo_mp_GeomTrans.html">demo_mp_GeomTrans</a> Illustrate usage of GeomTrans </li>
% </ul>
% </html>
%
%% Geometric utilities demos
% <html>
% <ul>
% <li><a href="demo_triangle_barycentric.html">demo_triangle_barycentric</a> Barycentric coordinates in triangle</li>
% <li><a href="demo_triangle_rand_points.html">demo_triangle_rand_points</a> Random points in triangle</li>
% </ul>
% </html>
%
%% Other demos
% <html>
% <ul>
% <li><a href="demo_edges_in_triangles.html">demo_edges_in_triangles</a> Show numbering of edges in traingles</li>
% <li><a href="demo_circ_hole_mesh.html">demo_circ_hole_mesh</a> mesh in region with circular hole</li>
% <li><a href="demo_highlight_nodes.html">demo_highlight_nodes</a> highlight selected nodes</li>
% <li><a href="demo_highlight_elements.html">demo_highlight_elements</a> highlight selected elements</li>
% <li><a href="demo_labels.html">demo_labels</a> label mesh elements</li>
% <li><a href="demo_lshape_mesh.html">demo_lshape_mesh</a> generate mesh in L-shaped domain</li>
% <li><a href="demo_mesh_factory.html">demo_mesh_factory</a> generate several meshes for testing purposes</li>
% <li><a href="demo_rectangle_mesh.html">demo_rectangle_mesh</a> generate mesh in rectangle</li>
% <li><a href="demo_triangles_vs_quads.html">demo_triangles_vs_quads</a> mesh in region with circular hole</li>
% <li><a href="demo_twin_squares_mesh.html">demo_twin_squares_mesh</a> mesh of squares with non-linear common boundary</li>
% <li><a href="demo_voids2D.html">demo_voids2D</a> mesh rectangular domain with circular voids</li>
% </ul>
% </html>
