for i = 0:TERMINAL.TERMINAL_NUMBER_OF_CONNECTIONS-1
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, i, 0);
end
clear i;
hil_close_all;
