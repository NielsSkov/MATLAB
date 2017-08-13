clear all; close all; clc

for fun = 1:3
  clearvars -except fun
  figure(fun);
  syms x;

  %function to be minimized
  %setting sensitivity for minimum-search
  if fun == 1
    f = sin(x)
    s = 0.01;
  elseif fun == 2
    f = 1+sin(x)^2
    s = 0.1;
  elseif fun == 3
    f = sin((x^(2))/5) %<--from this it is clear that the 
    s = 0.3;           %   search-method only finds
  end                  %   minimum candidates, not
                       %   the global minimum
  %the derivatives
  f_d = diff(f,x)
  f_dd = diff(f_d,x)

  %step vector for samples in x
  xs = .01:.1:10;

  %generating function vectors
  f = double(subs(f, x, xs));
  f_d = double(subs(f_d, x, xs));
  f_dd = double(subs(f_dd, x, xs));

  %plotting the resulting functions
  plot(xs,f, 'linewidth', 1.6, 'color', 'b')
  hold on
  plot(xs,f_d, 'linewidth', 1.6, 'color', 'r', 'linestyle', '--')
  plot(xs,f_dd, 'linewidth', 1.6, 'color', '[0 .5 0]')
  grid on; grid minor

  %minimum search
  for i = 1:length(xs)
    if f_d(i) < s && f_d(i) > -s  % == 0 +-sensitivity
      %extremum found
      if f_dd(i) > -s % >0 -sensitivity
        %minimum found
        %plotting minimum
        plot(xs(i),f(i), '.', 'markersize', 30, 'color', '[.4 0 .4]')
      end
    end
  end

  %giving a little more room in the y-direction of the plot
  limy = get(gca, 'ylim');
  ylim(limy+ limy/10)

  xlabel('$x$', 'interpreter', 'latex')
  ylabel('$f(x)$', 'interpreter', 'latex')
  
  leg = legend( '$f(x)$',...
                '$f''(x)$',...
                '$f''''(x)$',...
                'local min',...
                'location','southeast');
  set(leg, 'interpreter', 'latex')

end

