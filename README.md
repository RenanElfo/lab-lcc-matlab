# User Manual and Configuration of this Code

> [!NOTE]
> Para a documentação em português, vide [MELEIA.md](https://github.com/RenanElfo/lab-lcc-matlab/blob/main/MELEIA.md).

### Introduction:

&nbsp;&nbsp;&nbsp;&nbsp;This code was written to facilitate the use of control systems in the Laboratório de Controle por Computador (Instituto Tecnológico de Aeronáutica) without the need to use _Simulink_. It consists of several scripts and functions that, together, allow connecting, measuring, and sending signals to the plants using Quanser terminals — by default, it connects to a 'q8_usb' terminal, but it's also possible to specify a 'q2_usb' terminal — in a simplified and abstracted manner.

## Basic Usage:

&nbsp;&nbsp;&nbsp;&nbsp;For basic use of this code, it is necessary to pay attention to the use of three scripts: ``simulation.m``, ``load_setup.m``, and ``terminate.m``. Additionally, the functions contained in the ``read_write`` folder can be very useful for any projects that use this code. See below for a simple usage example of this code:

``` MATLAB
clc; clear; close all;
load_setup;

amplitude = 3;
frequency = 5;

control = amplitude*sin(2*pi*frequency*SIMULATION.TIME);
encoder = zeros(1, size(SIMULATION.TIME, 2));
tachometer = zeros(1, size(SIMULATION.TIME, 2));
for k = 0:SIMULATION.DURATION/SIMULATION.SAMPLING_PERIOD
    tic;
    send_control(control(k+1), 1);
    encoder(k+1) = read_encoder_rad(1);
    tachometer(k+1) = read_tachometer_rad_per_sec(1);
    while(toc < SIMULATION.SAMPLING_PERIOD); end
end

terminate;

figure(); hold on;
plot(SIMULATION.TIME, control, 'red');
plot(SIMULATION.TIME, encoder, 'green');
plot(SIMULATION.TIME, tachometer, 'blue');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Control (V)', 'Encoder (rad)', 'Tachometer (rad/s)');
hold off;
```

> [!IMPORTANT]
> The scripts load_setup.m and terminate.m should be run at the beginning and end of the simulation, respectively. More information about these scripts can be found in the section [General Scripts](https://github.com/RenanElfo/lab-lcc-matlab/blob/main/README.md#general-scripts).

> [!IMPORTANT]
> The script ``simulation.m`` contains the sampling time and duration information used in this simulation, accessible through the variable ``SIMULATION``. Its use is optional but encouraged.

> [!NOTE]
> The parameter 1 passed to the functions send_control, read_encoder_rad, and read_tachometer_rad_per_sec means that we are using the first control signal, the first encoder, and the first tachometer of the system, respectively. ***It does not refer to the connection port. For more information, see the sections [General Scripts](https://github.com/RenanElfo/lab-lcc-matlab/blob/main/README.md#general-scripts) and [Read and Write Functions](https://github.com/RenanElfo/lab-lcc-matlab/blob/main/README.md#read-and-write-functions).***

## In Depth Usage:
### General Scripts:

&nbsp;&nbsp;&nbsp;&nbsp;In this code, there are seven scripts that can be considered the "main" ones. They are:
* ``analog_input.m``: contains the necessary information for using the system's analog inputs. These inputs are connected in the terminal area labeled "Analog Inputs". Examples of analog inputs include potentiometers, extensometer, and tachometers. Each different type of analog input has distinct fields with relevant information for its operation, so it is up to the user to at least know the nominal values. It is recommended that any other type of analog input be added to this file following the code's stylistic pattern, particularly the ``.CONNECTION`` field, which should contain information on the connection channel of the analog input to the Quanser terminal.
* ``controls.m``: contains information about the control signals that will be sent to the plant through the terminal. It has only two fields: ``.CONNECTION``, which stores the control's connection channel on the terminal — in the area labeled "Analog Outputs"; and ``.MAX_CONTROL``, which is the maximum value, in absolute terms, of the control, to provide greater safety for lab users and protect the control systems.
* ``encoders.m``: contains the necessary information for collecting data regarding the angle of the encoders. The ``.CONNECTION`` field holds the connection port number of the encoder on the Quanser terminal. Additionally, it includes the encoder count per revolution, the quadrature mode in which it will operate, and the ``.ENCODER_INITIAL_VALUE`` field, which specifies the desired initial encoder count. This script also initializes the encoders with the specified quadrature mode and initial count.
* ``simulation.m``: script containing information about the simulation to be performed. Specifically: the sampling time and the duration of the simulation, as well as a vector containing all the sampling moments from the beginning of the simulation to its end. This script is generally optional but provides greater convenience.
* ``terminal.m``: contains information about the type of terminal, which can be either 'q8_usb' or 'q2_usb'. It also establishes the connection between the Quanser terminal and the computer and stores the handle necessary for sending and receiving information from it. It is important to note that the specified number of connections must match the type of terminal being used.
* ``load_setup.m``: this is the most important script of the code, as it is responsible for loading all the information from the aforementioned scripts and executing all connection actions. Additionally, it loads the functions from the ``read_write`` and ``rotary_servo`` folders (see the following sections). It is recommended that this script be at the beginning of any script that will use this project or be executed in the Command Window of MATLAB to facilitate the use of the laboratory's control systems.
* ``terminate.m``: sets to zero the control signal sent through the "Analog Outputs" ports of the terminal and then closes the connection between the terminal and the computer. It is recommended to run this script right after ending the simulation, either in a script or in the Command Window.
> [!WARNING]
> It is important to note that, for version 2.2 of Quarc, an error is generated when attempting to connect to the terminal, which occurs when running the scripts ``terminal.m`` or ``load_setup.m`` if it is already connected. Therefore, for this version, it is necessary to run the script ``terminate.m`` at the end of every simulation to avoid errors when attempting to run the simulation again. If it is not possible to execute ``terminate.m``, MATLAB should be restarted.

> [!NOTE]
> The information in the files is standardized for use with the rotary servo motor, except for the ``.CONNECTION`` fields — present in the scripts ``analog_input.m``, ``controls.m``, and ``encoders.m`` — which depend on the setup and may have been changed since this document was written.

#### Read and Write Functions:

&nbsp;&nbsp;&nbsp;&nbsp;In the ``read_write`` folder, there are 5 useful functions for reading analog and digital values, as well as for "writing", i.e., sending the control signal to the system. They are:
* ``send_control``: sends the control signal to the system. It receives two parameters: ``control_signal``, the value of the control to be sent to the system in volts; and ``control``, the ``control``-th control of the system, which can be configured in the script ``controls.m``.
* ``read_tachometer_rad_per_sec``: reads the signal from the tachometer in radians per second. It receives the parameter ``tachometer``, which refers to the ``tachometer``-th tachometer of the system to be read.
* ``read_extensometer``: reads the signal from the extensometer, both in volts and in millimeters. It receives the parameter ``extensometer``, which refers to the ``extensometer``-th extensometer of the system to be read.
* ``read_encoder_rad``: reads the signal from the encoder in radians. It receives the parameter ``encoder``, which refers to the ``encoder``-th encoder of the system to be read.
* ``read_encoder_deg``: reads the signal from the encoder in degrees. It receives the parameter ``encoder``, which refers to the ``encoder``-th encoder of the system to be read.

> [!IMPORTANT]
> Note that the parameters ``control``, ``tachometer``, ``extensometer``, and ``encoder`` received by the functions do not refer to the connection of these signals in the terminals, but to their index in the cells ``CONTROLS``, ``TACHOMETERS``, ``EXTENSOMETERS``, and ``ENCODERS``, respectively. This is due to the fact that some control systems in the laboratory have multiple signals for encoders, controls, etc. It is possible to modify the connection information in the scripts ``controls.m``, ``analog_inputs.m``, and ``encoders.m``.

> [!IMPORTANT]
> It is possible that, with the introduction of some analog signals different from those already presented, it may be necessary to write new functions for the ``read_write`` folder or simply use the ``hil_read_analog`` function from Quarc directly.

### Rotary Servo:

&nbsp;&nbsp;&nbsp;&nbsp;As a way to exemplify the functioning of this code, a PI control project — for angular velocity control — and a PD control project — for angle control — were carried out for the rotary servo.

&nbsp;&nbsp;&nbsp;&nbsp;To do this, the system model was raised: based on the nominal values and transfer functions provided in the user manual for the rotary servo, made available by Quanser, a simulation was conducted using the script ``motor_transfer_function.m`` to empirically collect the step response of the motor. With the numerical values obtained, a curve fitting was performed for each voltage, and the DC gain for each voltage value was calculated, with the average of these values being considered the DC gain of the motor. To find the motor's pole, all the step responses obtained were normalized, and a curve fitting was performed.
> [!NOTE]
> The model obtained for the rotary servo was stored in the field ``.ANGULAR_VELOCITY_OVER_VOLTAGE_EMPIRICAL`` of the global variable ``ROTARY_SERVO`` and can be found at the end of the script ``rotary_servo.m``.

&nbsp;&nbsp;&nbsp;&nbsp;Based on the empirically obtained system model, MATLAB's sisotool was used to obtain the desired PI and PD controllers. It is possible to run the scripts ``angular_velocity_controller`` and ``angle_controller.m`` to verify the restoration of angular velocity and angle in response to disturbances by hand.
> [!CAUTION]
> Be cautious when placing your hand near a running motor, especially when executing the script ``angular_velocity_controller``, as if your hand, clothing, or hair gets caught in the gears, the motor will compensate for the additional load by turning with more force.

&nbsp;&nbsp;&nbsp;&nbsp;Finally, within the ``rotary_servo`` folder, there is also a script for calibrating the tachometer, which obtains sensitivity through curve fitting of empirically obtained values based on the nominal value provided in the user manual for the rotary servo supplied by Quanser; and a script for calibrating the extensometer of the flexible link that can be attached to the rotary servo.
