function quadratic_error = tachometer_error(angular_velocitiy_encoder, angular_velocity_tachometer, sensitivity)
    quadratic_error = sum((angular_velocitiy_encoder - sensitivity*angular_velocity_tachometer).^2);
end

