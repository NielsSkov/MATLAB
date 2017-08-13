clear all; close all; clc

s = tf('s')

%Open Loop
L = 1/(s*(s+1))

%Proportional controller
Kp = sqrt(2) % = 3 dB

%plot nyquist of plant
nyqlog(L)
hold on
%Plot nyquist with proportional controller
nyqlog(Kp*L)

%plotting the same, but with matlab's native 
%nyquist function - for showing stability margins
figure
nyquist(L)
hold on
nyquist(Kp*L)

grid on, grid minor
xlim([-1.5 1.5])
ylim([-1.5 1.5])


%  ONLY POSSIBLE TO MANUALLY ENABLE STABILITY MARGINS, UNFORTUNATLY
%
%  You cannot set "Minimum Stability Margins" by default on Nyquist plots
%  in Control System Toolbox 8.0 (R2007a) and there are no workarounds.
%
%  However, you can observe the "Minimum Stability Margins" after you
%  plot the Nyquist diagram. To do so,
%
%    1. Make sure the 'arrow' (default) is selected as cursor tool
%    2. Right click in the display area of the Nyquist figure window.
%    3. Select the "Characteristics" tab.
%    4. Check the "Minimum Stability Margins" option.



