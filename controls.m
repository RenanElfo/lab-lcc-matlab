% This script includes informations regarding the control signals of the
% control system. Add new controls as required.

global CONTROL_CONNECTIONS

% Preconfigured for rotary servo
CONTROL_01.CONNECTION = 0;
CONTROL_01.MAX_CONTROL = 5;
CONTROL_CONNECTIONS{1} = CONTROL_01;

% Example
CONTROL_02.CONNECTION = 4;
CONTROL_02.MAX_CONTROL = 5;
CONTROL_CONNECTIONS{2} = CONTROL_02;

% Example
CONTROL_03.CONNECTION = 5;
CONTROL_03.MAX_CONTROL = 5;
CONTROL_CONNECTIONS{3} = CONTROL_03;

clear CONTROL_01;
clear CONTROL_02;
clear CONTROL_03;
