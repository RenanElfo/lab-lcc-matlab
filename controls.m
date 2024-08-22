% This script includes informations regarding the control signals of the
% control system. Add new controls as required.

global CONTROL_CONNECTIONS

CONTROL_01.CONNECTION = 0;
CONTROL_01.MAX_CONTROL = 5;
CONTROL_CONNECTIONS{1} = CONTROL_01;

CONTROL_02.CONNECTION = 4;
CONTROL_02.MAX_CONTROL = 5;
CONTROL_CONNECTIONS{2} = CONTROL_02;

clear CONTROL_01;
