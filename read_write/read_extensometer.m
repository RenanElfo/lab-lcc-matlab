function [voltage, deflection_mm] = read_extensometer(extensometer)
    load('constants');
    voltage = hil_read_analog(TERMINAL.TERMINAL_HANDLE, EXTENSOMETERS{extensometer}.CONNECTION);
    if isfield(EXTENSOMETERS{extensometer}, 'VOLTS_TO_MILLIMETER_NOMINAL')
        deflection_mm = voltage*EXTENSOMETERS{extensometer}.VOLTS_TO_MILLIMETER_NOMINAL;
    else
        message_part_1 = 'Warning: VOLTS_TO_MILLIMETER_NOMINAL field in EXTENSOMETER';
        message_part_2 = ['{', num2str(extensometer), '}'];
        message_part_3 = ' not assigned';
        message = strcat(message_part_1, message_part_2, message_part_3);
        disp(message);
        deflection_mm = NaN;
    end
end
