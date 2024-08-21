function send_control(control_signal, control)
    load('constants');
    maximum_voltage = CONTROL_CONNECTIONS{control}.MAX_CONTROL;
    if abs(control_signal) > maximum_voltage
        control_signal = CONTROL_CONNECTIONS{control}.MAX_CONTROL*sign(control_signal);
        message_part_1 = 'You''ve been saved by an elf: magnitude of the voltage sent';
        message_part_2 = ' larger than maximum allowed.';
        message_part_3 = ['Voltage was limited to ', num2str(control_signal), ' V.'];
        message_part_4 = ' You may change the maximum voltage setting in controls.m.';
        message_part_5 = 'Be careful, tho, because you may increase hazard changes by doing so.';
        disp(strcat(message_part_1, message_part_2));
        disp(strcat(message_part_3, message_part_4));
        disp(message_part_5);
    end
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{control}.CONNECTION, -control_signal);
end

