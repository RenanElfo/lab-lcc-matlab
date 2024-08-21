function angle_over_voltage_tf = rotary_servo_angular_velocity_tf(eta_g, eta_m, K_t, K_g, J_eq, R_m, B_eq, K_m)
    numerator = eta_g*eta_m*K_t*K_g;
    denominator = [J_eq*R_m, (B_eq*R_m + eta_g*eta_m*K_m*K_t*K_g*K_g)];
    angle_over_voltage_tf = tf(numerator, denominator);
end
