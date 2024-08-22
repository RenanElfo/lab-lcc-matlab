% This script includes informations regarding the encoders of the control
% system. Add new encoders as required.

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

for i = 1:size(ENCODERS)
    hil_set_encoder_quadrature_mode( ...
        TERMINAL.TERMINAL_HANDLE, ENCODERS{i}.CONNECTION, ...
        ENCODERS{i}.ENCODER_QUADRATURE_MODE ...
    );
    hil_set_encoder_counts( ...
        TERMINAL.TERMINAL_HANDLE, ENCODERS{i}.CONNECTION, ...
        ENCODERS{i}.ENCODER_INITIAL_VALUE ...
    );
end

clear i;
clear RAD2DEG;
clear ENCODER_01;
