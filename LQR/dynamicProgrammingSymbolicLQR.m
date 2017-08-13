clear all; close all; clc

% DYNAMIC PROGRAMMING
%
% Mminimum Search for 1st Order System
%
%  x(k+1) = a*x(k) + b*u(k)
%
% Performance Function
%       N
%  I = sum x(k)^2 + q*u(k)^2
%      k=0
%
%  where N = 2
%
%------------------------------------

syms a b q
N = 2
syms x0 u0  %<--manual because matlab does not support 0-indexing
x = sym('x', [1 N]);
u = sym('u', [1 N]);

%optima cost from k to N:
%
%  J_k_N = min  [  ( x(k)^2 + q*u(k)^2 )  +  J_kp1_N( x(k+1) )  ]
%         u(k)    /                    \    /                  \
%                /                      \  /                    \
%               current cost at each u(k)  all above minimum costs
%
%  the minimum is found at u*(k)
%
%  x(k+1) is given by the plant: x(k+1) = a*x(k) + b*u(k)
%
%  NOTATION:
%  _kp1_N = from k+1 to N
%  u*(k) denotes minimizing control signal


%STEP 0: compute minimal cost at k = 2 (final cost)

% final minimizing control signal is set to 0
u(2) = 0;
u_min_2 = '0';

J_2_2 = x(2)^2 + q*u(2)^2


%STEP 1: compute minimal cost at k = 1
%
%  J_1_2 = min  [  ( x(1)^2 + q*u(1)^2 )  +  J_2_2( x(1+1) )   ]
%         u(1)    /                    \    /                \
%                /                      \  /                  \
%               current cost at each u(1)  the above minimum costs

%using the plant and the 
%states at k=1 to compute the states at k=2
%leading to the final minimal cost as seen from k=1
J_2_2 = subs(J_2_2, x(1+1), a*x(1) + b*u(1))

%function to be minimized
minimize = x(1)^2 +q*u(1)^2 + J_2_2;

%finding the minimum, u*(1), along u(1) where the derivative is 0
u_min_1 = solve( diff( minimize, u(1) ) == 0, u(1) )

%inserting minimal control cost in the function to be minimized
J_1_2 = simplify( subs(minimize, u(1), u_min_1) )


%STEP i: (this is loops of step 1 for longer horizon (N > 2) ) 


%STEP N: (STEP 2) - first it follows same procedure as the above
%
%  J_0_2 = min  [  ( x(0)^2 + q*u(0)^2 )  +  J_1_2( x(0+1) )   ]
%         u(0)    /                    \    /                \
%                /                      \  /                  \
%               current cost at each u(0)  the above minimum costs

%using the plant and the 
%states at k=0 to compute the states at k=1
%leading to the final minimal cost as seen from k=0
J_1_2 = subs(J_1_2, x(0+1), a*x0 + b*u0)

%function to be minimized
minimize = x0^2 +q*u0^2 + J_1_2;

%finding the minimum, u*(0), along u(0) where the derivative is 0
u_min_0 = solve( diff( minimize, u0 ) == 0, u0 )

%inserting minimal control cost in the function to be minimized
J_0_2 = simplify( subs(minimize, u0, u_min_0) )

%---here is an addition to the final step---
%
%inserting description of x(0) in u*(1)
u_min_1 = simplify( subs( u_min_1, x(1), a*x0+b*u_min_0 ))

fprintf('The Optimal Control Sequence is Given by:\n')
fprintf('u*(0) = %s\n', u_min_0)
fprintf('u*(1) = %s\n', u_min_1)
fprintf('u*(2) = %s\n', u_min_2)




