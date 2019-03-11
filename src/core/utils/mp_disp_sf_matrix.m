function mp_disp_sf_matrix(M, w, p)
% Display matrix colorizing its elements. Entries equal 1.0 are green,
% 0.0 are black, any other values are red.
  [r, c] = size(M);
  tol=1e-5;
  for i=1:r
    for j=1:c
      fprintf('  ');
      if abs(M(i,j)) < tol
         cprintf('Black','%*.*f', w, p, M(i,j));
      elseif abs(M(i,j)-1) < tol
         cprintf('*Green','%*.*f', w, p, M(i,j));
      else	 
         cprintf('Red', '%*.*f', w, p, M(i,j));
      end
    end
    fprintf('\n');
  end
end
