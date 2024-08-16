clc; clear; close all;

my_path = mfilename('fullpath')
my_parent_path = fileparts(fileparts(my_path))
old_path = addpath(my_parent_path, '-end');

load_setup;
