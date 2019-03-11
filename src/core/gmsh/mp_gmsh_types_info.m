%% Return characteristic of given GMSH element type
%
function [info] = mp_gmsh_types_info(varargin)
  mlock
  persistent gt 
  if isempty(gt)
    gt.type_1.type = 1;
    gt.type_1.nnodes = 2;
    gt.type_1.dim = 1;
    gt.type_1.shape = 'line';
    gt.type_1.description = '2-node line';
    gt.type_1.edges = {[1,2]};
  
    gt.type_2.type = 2;
    gt.type_2.nnodes = 3;
    gt.type_2.dim = 2;
    gt.type_2.shape = 'triangle';
    gt.type_2.description = '3-node triangle';
    gt.type_2.edges = cellfun(@uint32, {[1,2], [2,3], [3,1]}, 'UniformOutput', false);
    gt.type_2.nodes = [0,0,0;1,0,0;0,1,0];
  
    gt.type_3.type = 3;
    gt.type_3.dim = 2;
    gt.type_3.shape = 'quadrangle';
    gt.type_3.nnodes = 4;
    gt.type_3.description = '4-node quadrangle';
    gt.type_3.edges = cellfun(@uint32, {[1,2], [2,3], [3, 4], [4,1]}, 'UniformOutput', false);
    gt.type_3.nodes = [0,0,0;1,0,0;1,1,0;0,1,0];
  
    gt.type_4.type = 4;
    gt.type_4.dim = 3; 
    gt.type_4.shape = 'tetrahedron';
    gt.type_4.nnodes = 4;
    gt.type_4.description = '4-node tetrahedron';
    gt.type_4.edges = cellfun(@uint32, {[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]}, 'UniformOutput', false);
  
    gt.type_5.type = 5;
    gt.type_5.dim = 3;
    gt.type_5.shape = 'hexahedron';
    gt.type_5.nnodes = 8; 
    gt.type_5.description = '8-node hexahedron';
    gt.type_5.edges = cellfun(@uint32, {[1,2], [2,3], [3,4], [4,1], 
                       [5,6], [6,7], [7,8], [8,5]}, 'UniformOutput', false);
  
    gt.type_6.type = 6;
    gt.type_6.dim = 3; 
    gt.type_6.shape = 'prism';
    gt.type_6.nnodes = 6; 
    gt.type_6.description = '6-node prism';
  
    gt.type_7.type = 7;
    gt.type_7.dim = 3;
    gt.type_7.shape = 'pyramid';
    gt.type_7.nnodes = 5;
    gt.type_7.description = '5-node pyramid';
  
    gt.type_8.type = 8;
    gt.type_8.dim = 1;
    gt.type_8.shape = 'line';
    gt.type_8.nnodes = 3;
    gt.type_8.description = '3-node second order line (2 nodes associated with the vertices and 1 with the edge)';
    gt.type_8.edges = {uint32([1,3,2])};
    
    gt.type_9.type = 9;
    gt.type_9.dim = 2;
    gt.type_9.shape = 'triangle';
    gt.type_9.nnodes = 6;
    gt.type_9.description = '6-node second order triangle (3 nodes associated with the vertices and 3 with the edges)';
    gt.type_9.edges = cellfun(@uint32, {[1,4,2],[2,5,3],[3,6,1]}, 'UniformOutput', false);
    gt.type_9.nodes = [0,0,0; 1,0,0; 0,1,0; 0.5,0,0;0.5,0.5,0;0,0.5,0];
    
    gt.type_10.type = 10;
    gt.type_10.dim = 2;
    gt.type_10.shape = 'quadrangle';
    gt.type_10.nnodes = 9;
    gt.type_10.description = '9-node second order quadrangle (4 nodes associated with the vertices, 4 with the edges and 1 with the face)';
    gt.type_10.edges = cellfun(@uint32, {[1,5,2], [2,6,3], [3,7,4], [4,8,1]}, 'UniformOutput', false);
   
    gt.type_11.type = 11;
    gt.type_11.dim = 3; 
    gt.type_11.shape = 'tetrahedron';
    gt.type_11.nnodes = 10;
    gt.type_11.description = '10-node second order tetrahedron (4 nodes associated with the vertices and 6 with the edges)';
  
    gt.type_12.type = 12;
    gt.type_12.dim = 3; 
    gt.type_12.shape = 'hexahedron';
    gt.type_12.nnodes = 27;
    gt.type_12.description = '27-node second order hexahedron (8 nodes associated with the vertices, 12 with the edges, 6 with the faces and 1 with the volume)';
  
    gt.type_13.type = 13;
    gt.type_13.dim = 3; 
    gt.type_13.shape = 'prism';
    gt.type_13.nnodes = 18;
    gt.type_13.description = '18-node second order prism (6 nodes associated with the vertices, 9 with the edges and 3 with the quadrangular faces)';
  
    gt.type_14.type = 14;
    gt.type_14.dim = 3; 
    gt.type_14.shape = 'pyramid';
    gt.type_14.nnodes = 14;
    gt.type_14.description = '14-node second order pyramid (5 nodes associated with the vertices, 8 with the edges and 1 with the quadrangular face)';
  
    gt.type_15.type = 15;
    gt.type_15.dim = 0; 
    gt.type_15.shape = 'point';
    gt.type_15.nnodes = 1;
    gt.type_15.description = '1-node point';
    gt.type_15.edges = {uint32([1,1])};
  
    gt.type_16.type = 16;
    gt.type_16.dim = 2; 
    gt.type_16.shape = 'quadrangle';
    gt.type_16.nnodes = 8;
    gt.type_16.description = '8-node second order quadrangle (4 nodes associated with the vertices and 4 with the edges)';
    gt.type_16.edges = cellfun(@uint32, {[1,5,2], [2,6,3], [3,7,4], [4,8,1]}, 'UniformOutput', false);
    
    gt.type_17.type = 17;
    gt.type_17.dim = 3;
    gt.type_17.shape = 'hexahedron';
    gt.type_17.nnodes = 20;
    gt.type_17.description = '20-node second order hexahedron (8 nodes associated with the vertices and 12 with the edges)';
  
    gt.type_18.type = 18;
    gt.type_18.dim = 3;
    gt.type_18.shape = 'prism';
    gt.type_18.nnodes = 15;
    gt.type_18.description = '15-node second order prism (6 nodes associated with the vertices and 9 with the edges)';
  
    gt.type_19.type = 19;
    gt.type_19.dim = 3; 
    gt.type_19.shape = 'pyramid';
    gt.type_19.nnodes = 13;
    gt.type_19.description = '13-node second order pyramid (5 nodes associated with the vertices and 8 with the edges)';
  
    gt.type_20.type = 20;
    gt.type_20.dim = 2;
    gt.type_20.shape = 'triangle';
    gt.type_20.nnodes = 9;
    gt.type_20.description = '9-node third order incomplete triangle (3 nodes associated with the vertices, 6 with the edges)';
  
    gt.type_21.type = 21;
    gt.type_21.dim = 2;
    gt.type_21.shape = 'triangle';
    gt.type_21.nnodes = 10;
    gt.type_21.description = '10-node third order triangle (3 nodes associated with the vertices, 6 with the edges, 1 with the face)';
    gt.type_21.edges = cellfun(@uint32, {[1,4,5,2],[2,6,7,3],[3,7,8,1]}, 'UniformOutput', false);
    p1 = 1/3;
    p2 = 2/3;
    gt.type_21.nodes = ...
           [0.0, 0.0, 0.0;
            1.0, 0.0, 0.0;
            0.0, 1.0, 0.0;
	     p1, 0.0, 0.0;
	     p2, 0.0, 0.0;
	     p2, p1,  0.0;
	     p1, p2,  0.0;
	    0.0, p2,  0.0;
	    0.0, p1,  0.0;
            p1, p1, 0.0];

    gt.type_22.type = 22;
    gt.type_22.dim = 2;
    gt.type_22.shape = 'triangle';
    gt.type_22.nnodes = 12;
    gt.type_22.description = '12-node fourth order incomplete triangle (3 nodes associated with the vertices, 9 with the edges)';
  
    gt.type_23.type = 23;
    gt.type_23.dim = 2;
    gt.type_23.shape = 'triangle';
    gt.type_23.nnodes = 15;
    gt.type_23.description = '15-node fourth order triangle (3 nodes associated with the vertices, 9 with the edges, 3 with the face)';
  
    gt.type_24.type = 24;
    gt.type_24.dim = 2;
    gt.type_24.shape = 'triangle';
    gt.type_24.nnodes = 15;
    gt.type_24.description = '15-node fifth order incomplete triangle (3 nodes associated with the vertices, 12 with the edges)';
  
    gt.type_25.type = 25;
    gt.type_25.dim = 2;
    gt.type_25.shape = 'triangle';
    gt.type_25.nnodes = 21;
    gt.type_25.description = '21-node fifth order complete triangle (3 nodes associated with the vertices, 12 with the edges, 6 with the face)';
  
    gt.type_26.type = 26;
    gt.type_26.dim = 1;
    gt.type_26.shape = 'line';
    gt.type_26.nnodes = 4;
    gt.type_26.description = '4-node third order edge (2 nodes associated with the vertices, 2 internal to the edge)';
  
    gt.type_27.type = 27;
    gt.type_27.dim = 1;
    gt.type_27.shape = 'line';
    gt.type_27.nnodes = 5;
    gt.type_27.description = '5-node fourth order edge (2 nodes associated with the vertices, 3 internal to the edge)';
  
    gt.type_28.type = 28;
    gt.type_28.dim = 2;
    gt.type_28.shape = 'line';
    gt.type_28.nnodes = 6;
    gt.type_28.description = '6-node fifth order edge (2 nodes associated with the vertices, 4 internal to the edge)';
  
    gt.type_29.type = 29;
    gt.type_29.dim = 3;
    gt.type_29.shape = 'tetrahedron';
    gt.type_29.nnodes = 20;
    gt.type_29.description = '20-node third order tetrahedron (4 nodes associated with th vertices, 12 with the edges, 4 with the faces)';
  
    gt.type_30.type = 30;
    gt.type_30.dim = 3;
    gt.type_30.shape = 'tetrahedron';
    gt.type_30.nnodes = 35;
    gt.type_30.description = '35-node fourth order tetrahedron (4 nodes associated with the vertices, 18 with the edges, 12 with the faces, 1 in the volume)';
  
    gt.type_31.type = 31;
    gt.type_31.dim = 3;
    gt.type_31.shape = 'hexahedron';
    gt.type_31.nnodes = 56;
    gt.type_31.description = '56-node fifth order tetrahedron (4 nodes associated with the vertices, 24 with the edges, 24 with the faces, 4 in the volume)';
  
    gt.type_92.type = 92;
    gt.type_92.dim = 3; 
    gt.type_92.shape = 'hexahedron';
    gt.type_92.nnodes = 64;
    gt.type_92.description = '64-node third order hexahedron (8 nodes associated with the vertices, 24 with the edges, 24 with the faces, 8 in the volume)';
  
    gt.type_93.type = 93;
    gt.type_93.dim = 3;
    gt.type_93.shape = 'hexahedron';
    gt.type_93.nnodes = 125;
    gt.type_93.description = '125-node fourth order hexahedron (8 nodes associated with the vertices, 36 with the edges, 54 with the faces, 27 in the volume)';
  
    gt.type_505.type = 505;
    gt.type_505.dim = 2;
    gt.type_505.shape = 'polygon';
    gt.type_505.nnodes = 5;
    gt.type_505.description = '5-node polygon';

    gt.type_506.type = 506;
    gt.type_506.dim = 2;
    gt.type_506.shape = 'polygon';
    gt.type_506.nnodes = 6;
    gt.type_506.description = '6-node polygon';

    gt.type_507.type = 507;
    gt.type_507.dim = 2;
    gt.type_507.shape = 'polygon';
    gt.type_507.nnodes = 7;
    gt.type_507.description = '7-node polygon';

    gt.type_508.type = 508;
    gt.type_508.dim = 2;
    gt.type_508.shape = 'polygon';
    gt.type_508.nnodes = 8;
    gt.type_508.description = '8-node polygon';

    gt.type_509.type = 509;
    gt.type_509.dim = 2;
    gt.type_509.shape = 'polygon';
    gt.type_509.nnodes = 9;
    gt.type_509.description = '9-node polygon';

    gt.type_510.type = 510;
    gt.type_510.dim = 2;
    gt.type_510.shape = 'polygon';
    gt.type_510.nnodes = 10;
    gt.type_510.description = '10-node polygon';

    gt.type_511.type = 511;
    gt.type_511.dim = 2;
    gt.type_511.shape = 'polygon';
    gt.type_511.nnodes = 11;
    gt.type_511.description = '11-node polygon';

    gt.type_512.type = 512;
    gt.type_512.dim = 2;
    gt.type_512.shape = 'polygon';
    gt.type_512.nnodes = 12;
    gt.type_512.description = '12-node polygon';

    gt.type_513.type = 513;
    gt.type_513.dim = 2;
    gt.type_513.shape = 'polygon';
    gt.type_513.nnodes = 13;
    gt.type_513.description = '13-node polygon';

    gt.type_514.type = 514;
    gt.type_514.dim = 2;
    gt.type_514.shape = 'polygon';
    gt.type_514.nnodes = 14;
    gt.type_514.description = '14-node polygon';

    gt.type_515.type = 515;
    gt.type_515.dim = 2;
    gt.type_515.shape = 'polygon';
    gt.type_515.nnodes = 15;
    gt.type_515.description = '15-node polygon';

    gt.type_516.type = 516;
    gt.type_516.dim = 2;
    gt.type_516.shape = 'polygon';
    gt.type_516.nnodes = 16;
    gt.type_516.description = '16-node polygon';
  end
  
  if nargin < 1
    info = gt;
  else
    arg = varargin{1};
    if ischar(arg)
      info = gt.(arg);
    else
      tt = sprintf('type_%d', arg);
      info = gt.(tt);
    end
  end
end
