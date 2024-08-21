clc; clear; close all;
load_setup;

angular_velocity_encoder = zeros(1, 11);
angular_velocity_tachometer = zeros(1, 11);
for voltage = 0:0.5:5
    control = -voltage + zeros(1, size(SIMULATION.TIME, 2));
    encoder = zeros(1, size(SIMULATION.TIME, 2));
    tachometer = zeros(1, size(SIMULATION.TIME, 2));
    for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
        tic;
        hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}.CONNECTION, control(k+1));
        encoder(k+1) = read_encoder_rad(1);
        tachometer(k+1) = hil_read_analog(TERMINAL.TERMINAL_HANDLE, TACHOMETERS{1}.CONNECTION);
        while(toc < SIMULATION.SAMPLING_PERIOD); end
    end
    angular_velocity_encoder(int32(2*voltage+1)) = (encoder(k)-encoder(1))/SIMULATION.DURATION;
    angular_velocity_tachometer(int32(2*voltage)+1) = mean(tachometer);
end

terminate;

quadratic_error_function = @(sensitivity) tachometer_error( ...
    angular_velocity_encoder, ...
    angular_velocity_tachometer, ...
    sensitivity ...
);
nominal_sensitivity = TACHOMETERS{1}.VOLTS_TO_RAD_PER_SEC_ON_MOTOR_NOMINAL/ROTARY_SERVO.SERVO_HIGH_GEAR_RATIO

sensitivity = fminsearch(quadratic_error_function, nominal_sensitivity)

figure(); hold on;
plot(0:0.5:5, angular_velocity_encoder, 'red');
plot(0:0.5:5, sensitivity*angular_velocity_tachometer, 'blue');
grid;
xlabel('Voltagem (V)');
ylabel('Velocidade Angular (rad/s)');
legend('Encoder', 'Tacômetro');
hold off;
