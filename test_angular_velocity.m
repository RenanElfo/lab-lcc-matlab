clc, clear, close all;
load_setup;

angular_velocity_encoder = zeros(1, 10);
angular_velocity_potentiometer = zeros(1, 10);
angular_velocity_tachometer = zeros(1, 10);
for voltage = 0.5:0.5:5
    control = -voltage + zeros(1, size(SIMULATION.TIME, 2));
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
    potentiometer(2:end) = (potentiometer(2:end) - potentiometer(1:(end-1)))/(SIMULATION.SAMPLING_PERIOD);
    potentiometer(1) = potentiometer(2);
    angular_velocity_encoder(int32(2*voltage)) = (encoder(k)-encoder(1))/SIMULATION.DURATION;
    angular_velocity_potentiometer(int32(2*voltage)) = -(35.2*pi/180)*mean(potentiometer(potentiometer < 0));
    angular_velocity_tachometer(int32(2*voltage)) = -mean(tachometer)/(9/(200*pi))/70;
end

terminate;

figure();
plot(0.5:0.5:5, angular_velocity_encoder, 'red');
grid;
xlabel('Voltagem (V)');
ylabel('Velocidade Angular (rad/s)');

figure();
plot(0.5:0.5:5, angular_velocity_potentiometer, 'green');
grid;
xlabel('Voltagem (V)');
ylabel('"Velocidade Angular" pelo Potenciometro (V/s)');

figure();
plot(0.5:0.5:5, angular_velocity_tachometer, 'blue');
grid;
xlabel('Voltagem do Controle (V)');
ylabel('Voltagem do Tacômetro (V)');