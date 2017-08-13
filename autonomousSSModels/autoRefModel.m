clear all; close all; clc

% Reference model:
%
% x(k+1) = phi_r * x(k)
% r(k) = eta_r * x(k)

%         _______                 ________
%        |       |   x(k)        |        |  r(k)
%   |--->|  z^-1 |--------|----->|  eta_r |------->
%   |    |_______|        |      |________|
%   |                     |
%   |     _______         |
%   |    |       |        |
%   |----| phi_r |<-------|
%        |_______|
%          

% initial condition defined
x_0 = 10

N = 100;

x = zeros(N,1);
r = zeros(N,1);

figure
%---STEP REFERENCE-------
%
for k = 0:N-1
  if k == 0
    x(k+1) = x_0;
    r_0 = x_0;
  else
    x(k+1) = x(k);
    r(k) = x(k);
  end
end

%plot([x_0; x])
%hold on
plot([r_0; r(1:N-1)]')
%
%-----------------------


clear all
figure
%---RAMP REFERENCE------
%

N = 100;

x1 = zeros(1,N);
x2 = zeros(1,N);

x = [ x1
      x2 ];

r = zeros(1,N);

K_1 = 5;

phi_r = [ 2 -1 
          1  0 ];

eta_r = [ 1 0 ];

x_0 = [   0
        -K_1 ];

for k = 0:N-1
  if k == 0
    x(:,k+1) = phi_r * x_0;
    r_0 = eta_r*x_0;
  else
    x(:,k+1) = phi_r * x(:,k);
    r(k) = eta_r*x(:,k);
  end
end

%plot([x_0(2,:) x(2,:)])
%hold on
plot([r_0 r(1,1:N-1)])
%
%-----------------------


clear all
figure
%---COSINE REFERENCE----
%

N = 20;

x1 = zeros(1,N*10+1);
x2 = zeros(1,N*10+1);

x = [ x1
      x2 ];

r = zeros(1,N*10+1);

K_2 = .5;
a = 1;

A1 = [   0   1 
     -(a^2) 0 ];

C1 = [ 1 0 ];

t=0:.1:20;
lsim(ss(A1,[0 0; 0 0],C1,[ 0 0 ]),zeros(length(t),2),t,[K_2 0]')
ylim([-4 4])
hold on

%discretizing the contineous state space description
sys_z = c2d(ss(A1,[0 0; 0 0],C1,[ 0 0 ]),.1,'zoh')

phi_r = sys_z.A;
eta_r = sys_z.C;

x_0 = [  K_2
          0  ];

for k = 0:N*10
  if k == 0
    x(:,k+1) = phi_r * x_0;
    r_0 = eta_r*x_0;
  else
    x(:,k+1) = phi_r * x(:,k);
    r(k) = eta_r*x(:,k);
  end
end

%plot([x_0(2,:) x(2,:)])
%hold on
plot(t,[r_0 r(1,1:N*10)],'*')
ylim([-5 5])
%
%-----------------------

