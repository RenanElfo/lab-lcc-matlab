% Function folder paths
addpath('read_write');

% Useful constants
global RAD2DEG
global DEG2RAD

RAD2DEG = 180/pi;
DEG2RAD = pi/180;

% Encoder Constants
global ENCODER_COUNTS_PER_TURN
global ENCODER_TO_RADIANS
global ENCODER_TO_DEGREES
global ENCODER_QUADRATURE_MODE
global ENCODER_INITIAL_VALUE

ENCODER_COUNTS_PER_TURN = 4096;
ENCODER_TO_RADIANS = 2*pi/ENCODER_COUNTS_PER_TURN;
ENCODER_TO_DEGREES = RAD2DEG*ENCODER_TO_RADIANS;
ENCODER_QUADRATURE_MODE = 4;
ENCODER_INITIAL_VALUE = 0;

% Connection Constants
global TERMINAL_CONNECTION
global CONTROL_CONNECTION
global ENCODER_CONNECTION
global TERMINAL

TERMINAL_CONNECTION = 8;
CONTROL_CONNECTION = 0;
ENCODER_CONNECTION = 0;
TERMINAL = hil_open('q8_usb');
hil_set_encoder_quadrature_mode(TERMINAL, ENCODER_CONNECTION, ENCODER_QUADRATURE_MODE);
hil_set_encoder_counts(TERMINAL, ENCODER_CONNECTION, ENCODER_INITIAL_VALUE);

save('constants')