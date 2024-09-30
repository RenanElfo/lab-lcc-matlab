# User Manual and Configuration of this Code

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
* ``analog_input.m``: It contains the necessary information for using the system's analog inputs. These inputs are connected in the terminal area labeled "Analog Inputs". Examples of analog inputs include potentiometers, strain gauges, and tachometers. Each different type of analog input has distinct fields with relevant information for its operation, so it is up to the user to at least know the nominal values. It is recommended that any other type of analog input be added to this file following the code's stylistic pattern, particularly the ``.CONNECTION`` field, which should contain information on the connection channel of the analog input to the Quanser terminal.
* ``controls.m``: It contains information about the control signals that will be sent to the plant through the terminal. It has only two fields: ``.CONNECTION``, which stores the control's connection channel on the terminal — in the area labeled "Analog Outputs"; and ``.MAX_CONTROL``, which is the maximum value, in absolute terms, of the control, to provide greater safety for lab users and protect the control systems.
* ``encoders.m``: It contains the necessary information for collecting data regarding the angle of the encoders. The ``.CONNECTION`` field holds the connection port number of the encoder on the Quanser terminal. Additionally, it includes the encoder count per revolution, the quadrature mode in which it will operate, and the ``.ENCODER_INITIAL_VALUE`` field, which specifies the desired initial encoder count. This script also initializes the encoders with the specified quadrature mode and initial count.
* ``simulation.m``: _script_ contendo informações a respeito da simulação a ser realizada. A saber: o tempo de amostragem e a duração da simulação, assim como um vetor contendo todos os instantes de amostragem do início da simulação até o seu término. Esse _script_ é, via de regra, dispensável, mas trás uma maior conveniência.
* ``terminal.m``: contém a informação do tipo de terminal, podendo ser este do tipo 'q8_usb' ou 'q2_usb'. Também realiza a conecção do terminal da Quanser com o computador e armazena o _handle_ necessário para enviar e receber informações dele. Vale ressaltar que o número de conecções especificado deve estar de acordo com o tipo de terminal utilizado.
* ``load_setup.m``: esse é o _script_ mais importante do código, sendo ele responsável por carregar todas as informações dos demais _scripts_ supracitados e executar todas as ações de conecção. Além disso, ele carrega as funções das pastas ``read_write`` e ``rotary_servo`` (vide próximas secções). Recomenda-se que ele esteja no início de todo _script_ que for utilizar esse projeto ou ser executado na Janela de Comandos (Command Window) do MATLAB a fim de facilitar o uso das plantas de controle do laboratório.
* ``terminate.m``: zera o sinal de controle enviado pelas portas de "Analog Outputs" do terminal e, em seguida, encerra a conecção do terminal com o computador. É recomendado rodar esse _script_ logo após encerrar a simulação, seja em um _script_ ou na Janela de Comandos.
> [!WARNING]
> É importante informar que, para a versão do Quarc 2.2, é gerado um erro ao tentar realizar a conecção com o terminal, algo que acontece quando se roda os _scripts_ ``terminal.m`` ou ``load_setup.m``, se ele já estiver conectado. É, pois, necessário, para essa versão, rodar o _script_ ``terminate.m`` ao fim de toda simulação, a fim de não gerar erro ao tentar realizar a simulação novamente. Caso não seja possível executar o ``terminate.m``, deve-se reiniciar o MATLAB.

> [!NOTE]
> As informações nos arquivos estão padronizadas para o uso no servo motor rotacional, com exceção dos campos ``.CONNECTION`` — presentes nos _scripts_ ``analog_input.m``, ``controls.m`` e ``encoders.m`` — que dependem da montagem e que podem ter sido alterados desde a escrita deste documento.

#### Read and Write Functions:

&nbsp;&nbsp;&nbsp;&nbsp;Na pasta ``read_write``, estão presentes 5 funções úteis para a leitura dos valores analógicos e digitais, assim como a "escrita", i.e., o envio, do sinal de controle para o sistema. Elas são:
* ``send_control``: envia o sinal de controle para o sistema. Recebe dois parâmetros: ``control_signal``, o valor do controle a ser enviado para o sistema, em volts; e ``control``, o ``control``-ésimo controle do sistema, que pode ser configurado no _script_ ``controls.m``.
* ``read_tachometer_rad_per_sec``: leitura do sinal do tacômetro, em radianos por segundo. Recebe o parâmetro ``tachometer``, que diz respeito ao ``tachometer``-ésimo tacômetro do sistema a ser lido.
* ``read_extensometer``: leitura do sinal do extensômetro, tanto em volts quando em milímetros. Recebe o parâmetro ``extensometer``, que diz respeito ao ``extensometer``-ésimo extensômetro do sistma a ser lido.
* ``read_encoder_rad``: leitura do sinal do encoder, em radianos. Recebe o parâmetro ``encoder``, que diz respeito ao ``encoder``-ésimo encoder do sistema a ser lido.
* ``read_encoder_deg``: leitura do sinal do encoder, em graus. Recebe o parâmetro ``encoder``, que diz respeito ao ``encoder``-ésimo encoder do sistema a ser lido.

> [!IMPORTANT]
> Note que os parâmetros ``control``, ``tachometer``, ``extensometer`` e ``encoder`` recebidos pelas funções ***não se referem à conecção desses sinais nos terminais, mas ao seu índice nas células ``CONTROLS``, ``TACHOMETERS``, ``EXTENSOMETERS`` e ``ENCODERS``, respectivamente***. Isso se deve ao fato de algumas plantas de controle no laboratório possuírem múltiplos sinais de encoder, ou controle, etc. É possível modificar as informações de conecções nos _scripts_ ``controls.m``, ``analog_inputs.m`` e ``encoders.m``.

> [!IMPORTANT]
> É possível que, com a introdução de alguns sinais analógicos diferentes dos já apresentados, seja necessário escrever novas funções para a pasta ``read_write`` ou, simplesmente, utilizar a função ``hil_read_analog`` do Quarc diretamente.

### Servo Rotacional:

&nbsp;&nbsp;&nbsp;&nbsp;Como forma de exemplificar o funcionamento deste código, foram realizados alguns projetos de controle PI — para controle de velocidade angular — e PD — para controle de ângulo — para o servo rotacional.

&nbsp;&nbsp;&nbsp;&nbsp;Para isso, foi levantado o modelo da planta: tomando como base os valores nominais e as funções de transferência fornecidos pelo manual de uso do servo rotacional, disponibilizado pela Quanser, foi realizada uma simulação, por meio do _script_ ``motor_transfer_function.m``, a fim de coletar a resposta ao degrau do motor de forma empírica. Com os valores numéricos obtidos, foi feito um ajuste de curva para cada voltagem e, com isso, foi obtido o ganho DC para cada valor de tensão e foi considerado como ganho DC do motor a média entre os valores obtidos. Para encontrar o polo do motor, foram normalizadas todas as respostas ao degrau obtidas e foi feito um ajuste de curva.
> [!NOTE]
> O modelo obtido para o servo rotacional foi armazenado no campo ``.ANGULAR_VELOCITY_OVER_VOLTAGE_EMPIRICAL`` da variável global ``ROTARY_SERVO`` e pode ser encontrada no final do _script_ ``rotary_servo.m``.

&nbsp;&nbsp;&nbsp;&nbsp;A partir do modelo da planta obtido empiricamente, foi utilizado o sisotool para se obterem os controladores PI e PD desejados. É possível rodar os _scripts_ ``angular_velocity_controller`` e ``angle_controller.m`` a fim de verificar a restauração da velocidade angular e do ângulo mediante perturbações com a mão.
> [!CAUTION]
> Tome cuidado ao colocar a mão em um motor em funcionamento, especialmente ao executar o _script_ ``angular_velocity_controller``, pois, caso a mão, a roupa ou o cabelo ficarem presos nas engrenagens, o motor irá compensar o esforço adicional girando com mais força.

&nbsp;&nbsp;&nbsp;&nbsp;Por fim, dentro da pasta ``rotary_servo``, também tem-se um _scripts_ para a calibração do tacômetro, que obtém a sensitividade por meio de ajuste de curva de valores obtidos empiricamente, a partir do valor nominal fornecido pelo manual de utilização do servo rotacional fornecido pela Quanser; e um _script_ para a calibração do extensômetro da régua flexível que é acoplável ao servo rotacional.
