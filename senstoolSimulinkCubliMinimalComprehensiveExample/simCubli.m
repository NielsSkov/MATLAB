% senstool's 'mainest.m' runs this file, 'simCubli.m', since,
% process = 'Cubli';
% is defined in 'CubliSenseTool.m' before running 'mainest.m',
% and 'mainest.m' looks for a simulation function of the name
% 'sim(process).m'
% that takes the inputs,
% 't', 'u' and 'par'

function y = simCubli( ~, ~, par )%<--| u (~) = input vector
                                  %   | t (~) = time vector
assignin('base', 'B_f', par(1));  %   | par   = [B_f J_f], model parameters
assignin('base', 'J_f', par(2));  %   | 
                                  %   | '~' indicates that the input is not
%t = [ 0  t(1:length(t)-1) ];     %   |     used but required by senstool

warning('off');
sim('CubliSenseToolSimOLD.slx'); %<--| the parameters, par, are assigned in
warning('on');                   %   | 'base'-workspace, such that simulink
                                 %   | can see them.

%output comes from a simulink 'to workspace'-block
y = output;

% IMPORTANT!
% The data provided to senstool must match number of samples and
% sample-time of the simulation.
% 
% In Simulink, see the 'to workspace'-block, in this case:
%
% limit data points to last:
% 2000
%
% sample time:
% 0.0025
%
% It is also a good idea to choose correct sampling in the simulink menu:
% 'Simulation' --> 'Model Configuration Parameters' --> [tab] Solver
% choose 'fixed step'
% choose an appropriate 'sampling time'
%
% --> [tab] Data 'Import/Export' --> [menu-point] 'Additional parameters'
% make sure that 'Limit data points to last' is NOT ticked
% since this is better addjusted in the 'to workspace'-block.