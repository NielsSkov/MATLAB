clear all; close all; clc

N = 14;
U = zeros(N,1);
X = zeros(N+1,1);
X(1) = 100; %<--initial value of state

for t = 1:20
  %clearvars -except realiz
  a = -1.2;
  b = -1;
  q = 4;

  syms x0 u0  %<--manual because matlab does not support 0-indexing
  x = sym('x', [1 N]);
  u = sym('u', [1 N]);

  J = sym('J', [N,1]);
  u_min = sym('u', [N,1]);

  %STEP 0: compute minimal cost at k = 2 (final cost)

  % final minimizing control signal is set to 0
  u(N) = 0;
  u_min(N) = '0';

  J(N) = x(N)^2 + q*u(N)^2;

  %STEP 1: (and step i) compute minimal cost at
  k = N;

  for i = 1:N-1
    k = k-1;

    %using the plant and the 
    %states at k=1 to compute the states at k=2
    %leading to the final minimal cost as seen from k=1
    J(k+1) = subs(J(k+1), x(k+1), a*x(k) + b*u(k));

    %function to be minimized
    minimize = x(k)^2 +q*u(k)^2 + J(k+1);

    %finding the minimum, u*(1), along u(1) where the derivative is 0
    u_min(k) = solve( diff( minimize, u(k) ) == 0, u(k) );

    %inserting minimal control cost in the function to be minimized
    J(k) = simplify( subs(minimize, u(k), u_min(k)) );
  end


  %STEP N: first it follows same procedure as the above

  %using the plant and the 
  %states at k=0 to compute the states at k=1
  %leading to the final minimal cost as seen from k=0
  J(1) = subs(J(1), x(0+1), a*x0 + b*u0);

  %function to be minimized
  minimize = x0^2 +q*u0^2 + J(1);

  %finding the minimum, u*(0), along u(0) where the derivative is 0
  u_min_0 = solve( diff( minimize, u0 ) == 0, u0 );

  %inserting minimal control cost in the function to be minimized
  J_0_2 = simplify( subs(minimize, u0, u_min_0) );

  %---here is an addition to the final step---
  %
  %inserting description of x(0) in u*(1)
  %u_min(1) = simplify( subs( u_min(1), x(1), a*x0+b*u_min_0 ))


  fprintf('The Optimal Control Signal:\n')
  fprintf('u*(0) = %s\n', vpa(u_min_0,5))
  L = double(subs(u_min_0,x0,1));

  U(t) = L*X(t)
  X(t+1) = a*X(t) + b*U(t)
  
  if t > 2
    plot([t-2 t-1]', X(t-1:t), 'b', 'linewidth', 1.2)
    hold on
    drawnow
  elseif t == 2
    plot([0 1]', X(1:2), 'b', 'linewidth', 1.2)
  end
end




