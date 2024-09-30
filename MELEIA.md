# Manual de uso e Configuração deste Código

### Introdução:

&nbsp;&nbsp;&nbsp;&nbsp;Este código foi escrito para facilitar a utilização das plantas de controle no Laboratório de Controle por Computador sem que seja necessário utilizar o _Simulink_. Ele consiste de vários _scripts_ que, juntos, permitem conectar, medir e enviar sinais para as plantas utilizando os terminais da Quanser — por padrão, ele se conecta em um terminal 'q8_usb', mas também é possível especificar um terminal 'q2_usb' — de forma simplificada e abstraída.

## Utilização:
### Utilização Básica:

&nbsp;&nbsp;&nbsp;&nbsp;Para uma utilização básica deste código, é necessário se atentar ao uso de três _scripts_: ``simulation.m``, ``load_setup.m`` e ``terminate.m``. Além disso, as funções contidas na pasta ``read_write`` podem ser muito úteis para quaisquer projetos que se utilizem deste código. Veja abaixo uma utilização simples deste código:

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
> Os _scripts_ ``load_setup.m`` e ``terminate.m`` devem ser rodados no início e no fim da simulação, respectivamente. Mais informações a respeito desses _scripts_ podem ser encontradas na secção [Utilização Aprofundada](https://github.com/RenanElfo/lab-lcc-matlab/blob/main/MELEIA.md#scripts-gerais).

> [!IMPORTANT]
> O _script_ ``simulation.m`` contém as informações de tempo de amostragem e duração que foram utilizadas nessa simulação, acessáveis pela variável ``SIMULATION``. Seu uso é dispensável, mas encorajado.

> [!NOTE]
> O parâmetro 1 que é passado para as funções ``send_control``, ``read_encoder_rad`` e ``read_tachometer_rad_per_sec`` significa que estamos pegando o primeiro sinal de controle, o primeiro encoder e o primeiro tacômetro do sistema, respectivamente. ***Ele não diz respeito à porta de conecção. Para mais informações, vide a secção [Funções de Leitura e Escrita]()***

### Utilização Aprofundada:
#### Scripts Gerais:

&nbsp;&nbsp;&nbsp;&nbsp;Existem, neste código, sete _scripts_ que podem ser considerados os "principais". Eles são:
* ``analog_input.m``: contém as informações necessárias para a utilização dos _inputs_ analógicos do sistema. Esses inputs estão conectados na região do terminal onde está escrito "Analog Inputs". São exemplos de _inputs_ analógicos os potenciômetros, extensômetros e tacômetros. Cada tipo diferente de entrada analógica possui campos distintos com informações relevantes para o seu funcionamento, então cabe ao usuário conhecer ao menos os valores nominais. Recomenda-se que qualquer outro tipo de _input_ analógico seja colocado nesse arquivo seguindo o padrão estilístico do código.
* ``controls.m``: contém as informações a respeito dos sinais de controle que serão enviados à planta pelo terminal. Possui dois campos apenas: ``.CONNECTION``, que guarda o canal de conexão do controle no terminal — na região onde se tem escrito "Analog Outputs"; e ``.MAX_CONTROl``, que é o valor máximo, em termos absolutos, do controle, a fim de fornecer uma maior segurança para os usuários do laboratório e proteger as plantas.
* ``encoders.m``: contém informações necessárias para a coleta de informações a respeito de ângulo dos encoders. Possui, no campo ``.CONNECTION``, o número da porta de connecção do encoder no terminal da Quanser. Além disso, contém a contagem do encoder em uma volta, o modo de quadratura no qual ele vai operar e o campo ``.ENCODER_INITIAL_VALUE`` que especifica qual a contagem inicial do encoder desejada. Esse _script_ também inicializa os encoders com o modo de quadratura e a contagem inicial especificados.
* ``simulation.m``: _script_ contendo informações a respeito da simulação a ser realizada. A saber: o tempo de amostragem e a duração da simulação, assim como um vetor contendo todos os instantes de amostragem do início da simulação até o seu término. Esse _script_ é, via de regra, dispensável, mas trás uma maior conveniência.
* ``terminal.m``: contém a informação do tipo de terminal, podendo ser este do tipo 'q8_usb' ou 'q2_usb'. Também realiza a conecção do terminal da Quanser com o computador e armazena o _handle_ necessário para enviar e receber informações dele. Vale ressaltar que o número de conecções especificado deve estar de acordo com o tipo de terminal utilizado.
* ``load_setup.m``: esse é o _script_ mais importante do código, sendo ele responsável por carregar todas as informações dos demais _scripts_ supracitados e executar todas as ações de conecção. Além disso, ele carrega as funções das pastas ``read_write`` e ``rotary_servo`` (vide próximas secções). Recomenda-se que ele esteja no início de todo _script_ que for utilizar esse projeto ou ser executado na Janela de Comandos (Command Window) do MATLAB a fim de facilitar o uso das plantas de controle do laboratório.
* ``terminate.m``: zera o sinal de controle enviado pelas portas de "Analog Outputs" do terminal e, em seguida, encerra a conecção do terminal com o computador. É recomendado rodar esse _script_ logo após encerrar a simulação, seja em um _script_ ou na Janela de Comandos.
> [!WARNING]
> É importante informar que, para a versão do Quarc 2.2, é gerado um erro ao tentar realizar a conecção com o terminal, algo que acontece quando se roda os _scripts_ ``terminal.m`` ou ``load_setup.m``, se ele já estiver conectado. É, pois, necessário, para essa versão, rodar o _script_ ``terminate.m`` ao fim de toda simulação, a fim de não gerar erro ao tentar realizar a simulação novamente. Caso não seja possível executar o ``terminate.m``, deve-se reiniciar o MATLAB.

> [!NOTE]
> As informações nos arquivos estão padronizadas para o uso no servo motor rotacional, com exceção dos campos ``.CONNECTION`` — presentes nos _scripts_ ``analog_input.m``, ``controls.m`` e ``encoders.m`` — que dependem da montagem e que podem ter sido alterados desde a escrita deste documento.

#### Funções de Leitura e Escrita:

&nbsp;&nbsp;&nbsp;&nbsp;Na pasta ``read_write``, estão presentes 5 funções úteis para a 

#### Servo Rotacional:

&nbsp;&nbsp;&nbsp;&nbsp;Como forma de exemplificar o funcionamento deste código, foram realizados alguns projetos de controle PI — para controle de velocidade angular — e PD — para controle de ângulo — para o servo rotacional.

&nbsp;&nbsp;&nbsp;&nbsp;Para isso, foi levantado o modelo da planta: tomando como base os valores nominais e as funções de transferência fornecidos pelo manual de uso do servo rotacional, disponibilizado pela Quanser, foi realizada uma simulação, por meio do _script_ ``motor_transfer_function.m``, a fim de coletar a resposta ao degrau do motor de forma empírica. Com os valores numéricos obtidos, foi feito um ajuste de curva para cada voltagem e, com isso, foi obtido o ganho DC para cada valor de tensão e foi considerado como ganho DC do motor a média entre os valores obtidos. Para encontrar o polo do motor, foram normalizadas todas as respostas ao degrau obtidas e foi feito um ajuste de curva.
> [!NOTE]
> O modelo obtido para o servo rotacional foi armazenado no campo ``.ANGULAR_VELOCITY_OVER_VOLTAGE_EMPIRICAL`` da variável global ``ROTARY_SERVO`` e pode ser encontrada no final do _script_ ``rotary_servo.m``.

&nbsp;&nbsp;&nbsp;&nbsp;A partir do modelo da planta obtido empiricamente, foi utilizado o sisotool para se obterem os controladores PI e PD desejados. É possível rodar os _scripts_ ``angular_velocity_controller`` e ``angle_controller.m`` a fim de verificar a restauração da velocidade angular e do ângulo mediante perturbações com a mão.
> [!CAUTION]
> Tome cuidado ao colocar a mão em um motor em funcionamento, especialmente ao executar o _script_ ``angular_velocity_controller``, pois, caso a mão, a roupa ou o cabelo ficarem presos nas engrenagens, o motor irá compensar o esforço adicional girando com mais força.

&nbsp;&nbsp;&nbsp;&nbsp;Por fim, dentro da pasta ``rotary_servo``, também tem-se um _scripts_ para a calibração do tacômetro, que obtém a sensitividade por meio de ajuste de curva de valores obtidos empiricamente, a partir do valor nominal fornecido pelo manual de utilização do servo rotacional fornecido pela Quanser; e um _script_ para a calibração do extensômetro da régua flexível que é acoplável ao servo rotacional.
