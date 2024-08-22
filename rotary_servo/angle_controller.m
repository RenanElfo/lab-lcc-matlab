% Example control obtained for sampling period equal to 0.002s.
clc; clear all; close all;
load_setup;

%{
G = tf(70, [1, 50, 0]);
zoh_effect = tf([-SIMULATION.SAMPLING_PERIOD/4, 1], [SIMULATION.SAMPLING_PERIOD/4, 1]);

% Obtained using sisotool(G)
Kp = 0.992;
C_pole = -9.8499;
C_zero = -17.096;
Kd = (C_pole-C_zero)*Kp/(C_zero);
C = tf([(Kd+Kp), -C_pole*Kp], [1, -C_pole]);
CG = series(C, G);

closed_loop = feedback(series(CG, zoh_effect), 1);
closed_loop_control_over_reference = feedback(C, series(G, zoh_effect));
C_z = c2d(C, SIMULATION.SAMPLING_PERIOD, 'zoh')

step(closed_loop); hold on;
step(closed_loop_control_over_reference); hold off;
%}

reference = pi/2;
u_k = 0;
u_k_minus_1 = 0;
error_k = 0;
error_k_minus_1 = 0;
control = zeros(1, size(SIMULATION.TIME, 2));
encoder = zeros(1, size(SIMULATION.TIME, 2));
for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
    tic;
    encoder(k+1) = read_encoder_rad(1);
    error_k = reference - encoder(k+1);
    maximum_voltage = CONTROL_CONNECTIONS{1}.MAX_CONTROL;
    if abs(u_k_minus_1 + 0.7156*error_k - 0.6453*error_k_minus_1) < maximum_voltage
        u_k = 0.9805*u_k_minus_1 + 0.5715*error_k - 0.5522*error_k_minus_1;
    else
        u_k = maximum_voltage*sign(0.9805*u_k_minus_1 + 0.5715*error_k - 0.5522*error_k_minus_1);
    end
    control(k+1) = u_k;
    send_control(u_k, 1);
    u_k_minus_1 = u_k;
    error_k_minus_1 = error_k;
    while(toc < SIMULATION.SAMPLING_PERIOD); end
end

terminate;

figure(); hold on;
plot(SIMULATION.TIME, encoder, 'red');
plot(SIMULATION.TIME, control, 'green');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Tachometer (rad/s)', 'Control (V)');
hold off;
