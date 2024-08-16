clc; clear; close all;
load_setup;

sine_frequency = 0.4;
%control = 5*sin(2*pi*sine_frequency*SIMULATION.TIME);
control = 5 + zeros(1, size(SIMULATION.TIME, 2));

encoder = zeros(1, size(SIMULATION.TIME, 2));
tachometer = zeros(1, size(SIMULATION.TIME, 2));
for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
    tic;
    send_control(control(k+1), 1);
    encoder(k+1) = read_encoder_rad(1);
    tachometer(k+1) = read_tachometer_rad_per_sec(1);
    while(toc < SIMULATION.SAMPLING_PERIOD); end
end

terminate;

figure();
plot(SIMULATION.TIME, control, 'blue');
grid;
xlabel('Tempo (s)');
ylabel('sin(t)');

figure();
plot(SIMULATION.TIME, encoder, 'red');
grid;
xlabel('Tempo (s)');
ylabel('Encoder Output');

figure();
plot(SIMULATION.TIME, tachometer, 'red');
grid;
xlabel('Tempo (s)');
ylabel('Encoder Output');

figure();
G = ROTARY_SERVO.ANGLE_OVER_VOLTAGE_NOMINAL;
step(series(G, tf([1, 0], 1)), SIMULATION.DURATION);
