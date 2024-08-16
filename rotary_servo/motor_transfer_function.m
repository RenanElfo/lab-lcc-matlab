% Sugested simulation values:
%   SAMPLING_TIME = 0.005;
%   DURATION = 0.2;
clc; clear; close all;
load_setup;

NUMBER_OF_ITERATIONS = 100;
VOLTAGE = -5:0.5:5;

tachometer_readings = cell(1, 20);
for voltage = 1:size(VOLTAGE, 2)
    if VOLTAGE(voltage) == 0
        continue
    end
    control = - VOLTAGE(voltage) + zeros(1, size(SIMULATION.TIME, 2));

    tachometer_iteration = zeros(1, size(SIMULATION.TIME, 2));
    tachometer = zeros(NUMBER_OF_ITERATIONS, size(SIMULATION.TIME, 2));
    for j = 1:NUMBER_OF_ITERATIONS
        for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
            tic;
            hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}.CONNECTION, control(k+1));
            tachometer_iteration(k+1) = read_tachometer_rad_per_sec(1);
            while(toc < SIMULATION.SAMPLING_PERIOD); end
        end
        tic;
        hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}.CONNECTION, 0);
        tachometer(j, :) = tachometer_iteration;
        while(toc < 2*SIMULATION.DURATION); end
    end
    tic;
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}.CONNECTION, 0);
    if VOLTAGE(voltage) < 0
        tachometer_readings{int32(2*VOLTAGE(voltage)+11)} = mean(tachometer, 1);
    elseif VOLTAGE(voltage) > 0
        tachometer_readings{int32(2*VOLTAGE(voltage)+10)} = mean(tachometer, 1);
    end
    while(toc < 3*SIMULATION.DURATION); end
end

terminate;

dc_gains = zeros(1, (size(VOLTAGE, 2)-1));
for voltage = 1:size(VOLTAGE, 2)
    if VOLTAGE(voltage) < 0
        index = int32(2*VOLTAGE(voltage) + 11);
    elseif VOLTAGE(voltage) == 0
        continue
    else
        index = int32(2*VOLTAGE(voltage) + 10);
    end

    quadratic_error = @(pole_gain) transfer_function_error( ...
        pole_gain, tachometer_readings{index}, VOLTAGE(voltage) ...
    );
    nominal_pole = pole(ROTARY_SERVO.ANGULAR_VELOCITY_OVER_VOLTAGE_NOMINAL);
    [~, nominal_gain] = zero(ROTARY_SERVO.ANGULAR_VELOCITY_OVER_VOLTAGE_NOMINAL);
    nominal_pole_gain = [nominal_pole, nominal_gain];

    empirical_pole_gain = fminsearch(quadratic_error, nominal_pole_gain);
    normalized_empirical_transfer_function = zpk([], empirical_pole_gain(1), empirical_pole_gain(2));
    dc_gains(index) = dcgain(normalized_empirical_transfer_function);

    tachometer_readings{index} = tachometer_readings{index}/tachometer_readings{index}(end);
end

tachometer_readings = mean(cell2mat(tachometer_readings'), 1);

quadratic_error = @(pole_gain) transfer_function_error(pole_gain, tachometer_readings, 1);
nominal_pole = pole(ROTARY_SERVO.ANGULAR_VELOCITY_OVER_VOLTAGE_NOMINAL);
[~, nominal_gain] = zero(ROTARY_SERVO.ANGULAR_VELOCITY_OVER_VOLTAGE_NOMINAL);
nominal_pole_gain = [nominal_pole, nominal_gain];

empirical_pole_gain = fminsearch(quadratic_error, nominal_pole_gain);
normalized_empirical_transfer_function = zpk([], empirical_pole_gain(1), empirical_pole_gain(2));
angular_velocity_from_transfer_function = step(normalized_empirical_transfer_function, SIMULATION.TIME);

figure(); hold on;
plot(SIMULATION.TIME, tachometer_readings, 'red');
plot(SIMULATION.TIME, angular_velocity_from_transfer_function, 'blue');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
legend('Tachometer', 'Empirical Transfer Function');
hold off;

final_transfer_function = series(mean(dc_gains), normalized_empirical_transfer_function)
