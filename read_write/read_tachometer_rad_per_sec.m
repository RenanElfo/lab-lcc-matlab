function angular_velocity = read_tachometer_rad_per_sec(tachometer)
    load('constants');
    angular_velocity_on_motor = TACHOMETERS{tachometer}.VOLTS_TO_RAD_PER_SEC_ON_MOTOR_EMPIRICAL*hil_read_analog( ...
        TERMINAL.TERMINAL_HANDLE, TACHOMETERS{tachometer}.CONNECTION ...
    );
    angular_velocity = - angular_velocity_on_motor / ROTARY_SERVO.SERVO_HIGH_GEAR_RATIO;
end
