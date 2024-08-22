% Useful constants
DEG2RAD = pi/180;
KILO_RPM_PER_RAD_PER_SEC = 60/(2000*pi);
INCHES_TO_MILLIMETER = 25.4;

% Potentiometers
global POTENTIOMETERS

% Example
POTENTIOMETER_01.DEGREES_PER_VOLT_NOMINAL = 35.2;
POTENTIOMETER_01.RADIANS_PER_VOLT_NOMINAL = DEG2RAD*POTENTIOMETER_01.DEGREES_PER_VOLT_NOMINAL;
POTENTIOMETER_01.CONNECTION = 0;
POTENTIOMETERS{1} = POTENTIOMETER_01;

% Tachometers
global TACHOMETERS

% Preconfigured for rotary servo
TACHOMETER_01.VOLTS_PER_KILO_RPM_NOMINAL = 1.5;
VOLTS_PER_RAD_PER_SEC_ON_MOTOR_NOMINAL = TACHOMETER_01.VOLTS_PER_KILO_RPM_NOMINAL*KILO_RPM_PER_RAD_PER_SEC;
TACHOMETER_01.VOLTS_TO_RAD_PER_SEC_ON_MOTOR_NOMINAL = 1/VOLTS_PER_RAD_PER_SEC_ON_MOTOR_NOMINAL;
TACHOMETER_01.VOLTS_TO_RAD_PER_SEC_ON_MOTOR_EMPIRICAL = 70.6381; % doesn't change a lot with physical setup
TACHOMETER_01.CONNECTION = 2;
TACHOMETERS{1} = TACHOMETER_01;

% Extensometers
global EXTENSOMETERS

% Preconfigured for rotary servo
EXTENSOMETER_01.CONNECTION = 3;
EXTENSOMETER_01.VOLTS_TO_INCH_NOMINAL = 1;
EXTENSOMETER_01.VOLTS_TO_MILLIMETER_NOMINAL = EXTENSOMETER_01.VOLTS_TO_INCH_NOMINAL*INCHES_TO_MILLIMETER;
EXTENSOMETERS{1} = EXTENSOMETER_01;

clear DEG2RAD;
clear KILO_RPM_PER_RAD_PER_SEC;
clear VOLTS_PER_RAD_PER_SEC_ON_MOTOR_NOMINAL;
clear POTENTIOMETER_01;
clear TACHOMETER_01;
clear EXTENSOMETER_01;
