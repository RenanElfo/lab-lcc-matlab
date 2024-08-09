function angle = read_encoder_deg(encoder)
    load('constants');
    angle = ENCODERS{encoder}.ENCODER_TO_DEGREES*hil_read_encoder( ...
        TERMINAL.TERMINAL_HANDLE, ENCODERS{encoder}.CONNECTION ...
    );
end

