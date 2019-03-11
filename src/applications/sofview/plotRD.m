function plotRD(L,H, bc, dir)
x = [0,L,L,0];
y = [0,0,H,H];
prop=0.02;
hold on
patch(x,y,'yellow', 'LineWidth',1);
southBC(L,H,bc(1),prop, dir);
eastBC(L,H,bc(2),prop, dir);
northBC(L,H,bc(3),prop, dir);
westBC(L,H,bc(4),prop, dir);
%axis([-2*L*prop, L+2*L*prop, -2*H*prop, H+2*H*prop]);
end
function southBC(L,H,type,prop,dir)
  offset=[0,-1]*prop*H;
  x = [0,L];
  y = [0,0];
  bcMarker(x,y,type,offset, dir);
end
function eastBC(L,H,type,prop, dir)
  offset=[1,0]*prop*L;
  x = [L,L];
  y = [0,H];
  bcMarker(x,y,type,offset,dir);
end
function northBC(L,H,type,prop,dir)
  offset=[0,1]*prop*H;
  x = [L,0];
  y = [H,H];
  bcMarker(x,y,type,offset,dir);
end
function westBC(L,H,type,prop,dir)
  offset=[-1,0]*prop*L;
  x = [0,0];
  y = [H,0];
  bcMarker(x,y,type,offset,dir);
end
function bcMarker(x,y,type,offset, dir)
  if strcmp(type,'free')
      return
  elseif strcmp(type, 'fixed')
      hatchedline(x,y,'-k');
  elseif strcmp(type, 'slider')
      x = x+offset(1);
      y = y+offset(2);
      hatchedline(x,y,'-k');
  elseif strcmp(type, 'traction')
      n =13;
      xa = linspace(x(1),x(2),n);
      ya = linspace(y(1),y(2),n);
      dd = offset;
      dir = dir/norm(dir);
      ds = norm([diff(x),diff(y)])/(n);
      F = ds*dir;
      u = F(1)*ones(1,n);
      v = F(2)*ones(1,n);
      loaddir = dot(dir, offset/norm(offset));
      lw=1;
      if abs(loaddir) < 1e-5
         dxy = dd;
         bdr = 0;
         quiver(xa+dxy(1),ya+dxy(2),u,v,0,'LineWidth',1);
      elseif loaddir > 0
         dxy = [0,0];
         bdr = 1;
         quiver(xa+dxy(1),ya+dxy(2),u,v,0,'LineWidth',1);
         line(x+F(1),y+F(2));
      else  
         bdr = 1;
         line(xa,ya);
         quiver(xa-u(1),ya-v(1),u,v,0,'LineWidth',1);
         line(xa-u(1),ya-v(1));
      end
  end
end