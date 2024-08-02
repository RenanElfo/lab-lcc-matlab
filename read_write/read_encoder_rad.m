function angle = read_encoder_rad()
    load('constants')
    angle = ENCODER_TO_RADIANS*hil_read_encoder(TERMINAL, ENCODER_CONNECTION);
end
