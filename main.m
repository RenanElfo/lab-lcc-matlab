clc, clear, close all;
load_constants_and_connect;

sampling_period = 0.01;
time_stop = 5;
time = 0:sampling_period:time_stop;
sine_frequency = 0.4;
control = -5*sin(2*pi*sine_frequency*time);
%control = zeros(1, size(time, 2));

output = zeros(1, size(time, 2));
for k = 0:time_stop/sampling_period
    hil_write_analog(TERMINAL, CONTROL_CONNECTION, control(k+1));
    output(k+1) = read_encoder_deg();
    tic; while(toc < sampling_period); end
end

terminate;

figure();
plot(time, control, 'blue');
grid;
xlabel('Tempo (s)');
ylabel('sin(t)');

figure();
plot(time, output, 'red');
grid;
xlabel('Tempo (s)');
ylabel('Encoder Output');