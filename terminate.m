for i = 0:TERMINAL_CONNECTION-1
    hil_write_analog(TERMINAL, i, 0);
end
clear i;
hil_close_all;
