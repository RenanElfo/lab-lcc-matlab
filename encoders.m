% Useful constants
RAD2DEG = 180/pi;

global ENCODERS

ENCODER_01.ENCODER_COUNTS_PER_TURN = 4096;
ENCODER_01.ENCODER_TO_RADIANS = 2*pi/ENCODER_01.ENCODER_COUNTS_PER_TURN;
ENCODER_01.ENCODER_TO_DEGREES = RAD2DEG*ENCODER_01.ENCODER_TO_RADIANS;
ENCODER_01.ENCODER_QUADRATURE_MODE = 4;
ENCODER_01.ENCODER_INITIAL_VALUE = 0;
ENCODER_01.CONNECTION = 0;
ENCODERS{1} = ENCODER_01;

clear RAD2DEG;
clear ENCODER_01;
