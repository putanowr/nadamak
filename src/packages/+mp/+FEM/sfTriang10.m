function Nb = sfTriang10(refPts)
    % Shape functions for classical quadratic Lagrangian triangle element
    % It is assumed that reference element is in normalized coordinates.
    % Arguments:
    %   * refPts - array (N by 2) of coordinates in reference element
    % Return:
    %    * arrany (N by 10) of shape function values at refPts
    x = refPts(:,1);
    y = refPts(:,2);
    z = 1 - x - y;
    npt = size(refPts, 1);
    Nb = zeros(npt,10);
    Nb(:,1)  = x.*(3*x - 1).*(3*x - 2)/2;
    Nb(:,2)  = 9*x.*y.*(3*x - 1)/2;
    Nb(:,3)  = 9*x.*y.*(3*y - 1)/2;
    Nb(:,4)  = y.*(3*y - 1).*(3*y - 2)/2;
    Nb(:,5)  = 9*z.*x.*(3*x - 2)/2;
    Nb(:,6)  = 27*x.*y.*z;
    Nb(:,7)  = 9*y.*z.*(3*y - 1)/2;
    Nb(:,8)  = 9*z.*x.*(3*y - 1)/2;
    Nb(:,9)  = 9*y.*z.*(3*y - 2)/2;
    Nb(:,10) = z.*(3*z - 1).*(3*z - 2);
end
