function mp_run_demos(options)
  sep = filesep();
  mypath = mfilename('fullpath');

  [pth,~,~] = fileparts(mypath);
  srcFolder = fullfile(pth,'..');
  addpath(srcFolder);

  nadamak_environ()
 
  exitOnFinish=mp_get_option(options, 'exitAfter', true);
  outputdir = mp_get_option(options, 'demodir', pth);

  demos =  {'triangles_vs_quads', true; 
            'triangle_barycentric', true;
	    'triangle_rand_points', true;
            'rectangle_mesh', true;
            'circ_hole_mesh', true;
            'edges_in_triangles', true;
            'FEM_FemType', true;
	    'FEM_shapeFunctions', true;
            'highlight_elements', true;
            'highlight_nodes', true;
	    'integrate', true;
            'labels', true;
            'LShapeGeom', true;
            'LShapeGeom_refinement', true;
            'LShapeIfaceGeom', true;
            'LShapeIfaceGeom_queries', true;
            'LShapeIfaceGeom_nonconforming', true;
            'LShapeIfaceGeom_normals', true;
            'lshape_mesh', true;
            'Mesh_edgeCenters', true;
            'Mesh_faceCenters', true;
            'Mesh_parent_child_submesh', true;
            'Mesh_submesh', true;
            'Mesher_square', true;
            'Mesher_globalField', true;
            'Mesher_refinement', true;
            'MeshFactory', true;
            'mesh_factory',true;
            'mp_enumerations', true;
            'mp_elems_centers', true;
            'mp_face_edge_data', true;
            'mp_face_edge_data_at_regions', true;
            'mp_GeomTrans', true;
            'mp_map_circle', true;
            'mp_readMesh', true;
            'mp_tagging_nodes', true;
            'mp_get_tagged_nodes', true;
            'mp_get_tagged_edges', true;
            'mp_tag_region_nodes', true;
            'mp_view_stars', true;
            'NotchedRQGeom', true;
	    'shake_internal_nodes', true;
            'SquareHoleGeom', true;
            'TriangleGeom', true;
	    'TriangleHighOrder', true;
            'TSHGeom', true;
            'twin_squares_mesh', true; 
            'Viewer', true;
            'voids2D', true};
  
  publishOptions = struct('format','html','outputDir', outputdir); 
  for i=1:size(demos,1)
    name = demos{i, 1};
    showcode = demos{i, 2};
    fname = ['demo_', name, '.m'];
    close all
    mp_manage_demos('register', name);
    publishOptions.showCode = showcode;
    if exist(fname, 'file') == 2
      publish(fname, publishOptions)
    else 
      fprintf(1, 'File %s not found', fname);
      mp_manage_demos('report', name, false);
    end
    mp_manage_demos('cleanup', name);
  end

  publishOptions.showCode = false;
  publish('list_of_demos.m', publishOptions)
  
  if exitOnFinish
    if ~mp_manage_demos('status') 
      exit(22)
    else
      exit(0)
    end
  end  
end
