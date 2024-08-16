clc; clear; close all;
load_setup;

voltage = zeros(1, 20);
while true
    tic;
    last_sample = hil_read_analog(TERMINAL.TERMINAL_HANDLE, 3);
    voltage(1:end-1) = voltage(2:end);
    voltage(end) = last_sample/size(voltage, 2);
    moving_average = sum(voltage)
    while(toc < SIMULATION.SAMPLING_PERIOD); end
end

