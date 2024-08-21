function quadratic_error = transfer_function_error(pole_gain, tachometer_readings, voltage)
    load('constants');
    transfer_function = zpk([], pole_gain(1), pole_gain(2));
    transfer_function_step_values = (voltage*step(transfer_function, SIMULATION.TIME))';
    quadratic_error = sum((transfer_function_step_values - tachometer_readings).^2);
end
