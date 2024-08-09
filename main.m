clc, clear, close all;
load_setup;

sine_frequency = 0.4;
%control = -5*sin(2*pi*sine_frequency*SIMULATION.TIME);
control = -5 + zeros(1, size(SIMULATION.TIME, 2));

encoder = zeros(1, size(time, 2));
potentiometer = zeros(1, size(time, 2));
tachometer = zeros(1, size(time, 2));
for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}, control(k+1));
    encoder(k+1) = read_encoder_rad(1);
    potentiometer(k+1) = hil_read_analog(TERMINAL.TERMINAL_HANDLE, 0);
    tachometer(k+1) = hil_read_analog(TERMINAL.TERMINAL_HANDLE, 2);
    tic; while(toc < SIMULATION.SAMPLING_PERIOD); end
end

terminate;

figure();
plot(SIMULATION.TIME, control, 'blue');
grid;
xlabel('Tempo (s)');
ylabel('sin(t)');

figure();
plot(SIMULATION.TIME, -tachometer, 'red');
grid;
xlabel('Tempo (s)');
ylabel('Encoder Output');

figure();
G = ROTARY_SERVO.ANGLE_OVER_VOLTAGE;
step(series(G, tf([1, 0], 1)), SIMULATION.DURATION);
