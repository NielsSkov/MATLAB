clear all; close all; clc

a = -3:.01:3;

L = length(a);

x = zeros(61,L);
y = zeros(61,L);
f = zeros(61,L);
fcomplex = zeros(61,L);

for k = -30:30
  b = -(k/10) + a*i;
  f(k+31,:) = b.^2 + 2.*b +2;
  
  fcomplex(k+31,:) = f(k+31,:);  %<--save all solutions (also complex)

  for c = 1:L
    if isreal( f(k+31,c) ) == 0 
      f(k+31,c) = nan;             %<--set complex intries in f to 0
    end
  end
  
  x(k+31,:) = real(b);
  y(k+31,:) = imag(b);
end

%%%%%%%%%% PLOT SHOWING REAL f-VALUES %%%%%%%%%%%
figure;
color = [ 0 .5 0 ];
for e = 1:61
  scatter3(x(e,:),y(e,:),f(e,:), 10,...
                                 'filled',...
                                 'MarkerFaceColor', color,...
                                 'MarkerEdgeColor', color)
  hold on
end

%%%%% SELECT WHAT TO PLOT %%%%%%
printReal = 1;                %%
printImag = 0;                %%
printAbs = 0;                 %%
print0plane = 1;              %%
printSol = 1;                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% ADDING PLANE OF REAL PARTS OF ALL f-VALUES %%%%%%%%%%
if printReal == 1
  f = real(fcomplex);
  surf(x,y,f, 'EdgeColor', 'none', 'FaceAlpha', '.5')
end
hold on

%%%%%%%%%% ADDING PLANE OF COMPLEX PARTS OF ALL f-VALUES %%%%%%%%%%
if printImag == 1
  f = imag(fcomplex);
  surf(x,y,f, 'EdgeColor', 'none', 'FaceAlpha', '.5')
end

%%%%%%%%%% ADDING PLANE OF ABSOLUTE OF ALL f-VALUES %%%%%%%%%%
if printAbs == 1
  f = abs(fcomplex);
  surf(x,y,f, 'EdgeColor', 'none', 'FaceAlpha', '.5')
end

%%%%%%%%%% ADDING f = 0 PLANE %%%%%%%%%%%
if print0plane == 1
  [xx,yy] = meshgrid(-3:0.1:3, -3:0.1:3);
  zz = 0*xx+0*yy;
  surf(xx,yy,zz, 'EdgeColor', 'none', 'FaceColor', 'b', 'FaceAlpha', '.7')
end

%%%%%%%%% ADDING SOLUTIONS %%%%%%%%%
if printSol == 1
  syms x;
  f = x^2 + 2*x + 2
  sol = solve( f == 0, x )
  scatter3(real(sol),imag(sol), [0 0], 80, 'r', 'filled')
end

