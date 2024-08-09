% Function folder paths
addpath('read_write');
addpath('rotary_servo');

% Encoder constants
encoders;

% Control constants
controls;

% Terminal constants
terminal;

% Making connections
connect;

% Simulation Constants
simulation;

% Plant constants
rotary_servo;

save('constants')
