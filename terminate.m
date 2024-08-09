for i = 0:TERMINAL.TERMINAL_CONNECTION-1
    hil_write_analog(TERMINAL.TERMINAL_HANDLE, i, 0);
end
clear i;
hil_close_all;
