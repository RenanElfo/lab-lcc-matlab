% Function folder paths
addpath('read_write');
addpath('rotary_servo');
addpath('maybe_useful');

% Encoder constants
encoders;

% Analog input constants
analog_inputs;

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
