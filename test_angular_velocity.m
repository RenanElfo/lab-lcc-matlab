clc, clear, close all;
load_setup;

angular_velocity_encoder = zeros(1, 11);
angular_velocity_tachometer = zeros(1, 11);
for voltage = 0:0.5:5
    control = -voltage + zeros(1, size(SIMULATION.TIME, 2));
    encoder = zeros(1, size(time, 2));
    tachometer = zeros(1, size(time, 2));
    for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
        hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{1}, control(k+1));
        encoder(k+1) = read_encoder_rad(1);
        tachometer(k+1) = hil_read_analog(TERMINAL.TERMINAL_HANDLE, 2);
        tic; while(toc < SIMULATION.SAMPLING_PERIOD); end
    end
    angular_velocity_encoder(int32(2*voltage+1)) = (encoder(k)-encoder(1))/SIMULATION.DURATION;
    angular_velocity_tachometer(int32(2*voltage)+1) = mean(tachometer);
end

terminate;

figure(); hold on;
plot(0:0.5:5, angular_velocity_encoder, 'red');
plot(0:0.5:5, (8.357/7.866)*((-1)/(9/(200*pi))/70)*angular_velocity_tachometer, 'blue');
grid;
xlabel('Voltagem (V)');
ylabel('Velocidade Angular pelo Encoder (rad/s)');
hold off;

%{
figure();
plot(0:0.5:5, angular_velocity_tachometer, 'blue');
grid;
xlabel('Voltagem do Controle (V)');
ylabel('Velocidade Angular pelo Tacômetro (rad/s)');
%}