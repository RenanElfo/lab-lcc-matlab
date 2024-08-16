function send_control(control_signal, control)
    load('constants');
    if control_signal > CONTROL_CONNECTIONS{control}.MAX_CONTROL
        control_signal = CONTROL_CONNECTIONS{control}.MAX_CONTROL*sign(control_signal);
    end
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, CONTROL_CONNECTIONS{control}.CONNECTION, -control_signal);
end

