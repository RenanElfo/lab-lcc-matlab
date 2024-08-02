function angle = read_encoder_deg()
    load('constants')
    angle = ENCODER_TO_DEGREES*hil_read_encoder(TERMINAL, ENCODER_CONNECTION);
end

