# Manual de uso e Configuração deste Código

### Introdução:

&nbsp;&nbsp;&nbsp;&nbsp;Este código foi escrito para facilitar a utilização das plantas de controle no Laboratório de Controle por Computador sem que seja necessário utilizar o _Simulink_. Ele consiste de vários _scripts_ que, juntos, permitem conectar, medir e enviar sinais para as plantas utilizando os terminais da Quanser — por padrão, ele se conecta em um terminal 'q8_usb', mas também é possível especificar um terminal 'q2_usb' — de forma simplificada e abstraída.

## Utilização:
### Utilização Básica:



### Utilização Aprofundada:

&nbsp;&nbsp;&nbsp;&nbsp;Existem, neste código, sete _scripts_ que podem ser considerados os "principais". Eles são:
* ``analog_input.m``: contém as informações necessárias para a utilização dos _inputs_ analógicos do sistema. Esses inputs estão conectados na região do terminal onde está escrito "Analog Inputs". São exemplos de _inputs_ analógicos os potenciômetros, extensômetros e tacômetros. Cada tipo diferente de entrada analógica possui campos distintos com informações relevantes para o seu funcionamento, então cabe ao usuário conhecer ao menos os valores nominais. Recomenda-se que quaisquer outro tipo de _input_ analógico seja colocado nesse arquivo seguindo o padrão estilístico do código.
* ``controls.m``: contém as informações a respeito dos sinais de controle que serão enviados à planta pelo terminal. Possui dois campos apenas: ``.CONNECTION``, que guarda o canal de conexão do controle no terminal — na região onde se tem escrito "Analog Outputs"; e ``.MAX_CONTROl``, que é o valor máximo, em termos absolutos, do controle, a fim de fornecer uma maior segurança para os usuários do laboratório e proteger as plantas.
* ``encoders.m``: contém informações necessárias para a coleta de informações a respeito de ângulo dos encoders. Possui, no campo ``.CONNECTION``, o número da porta de connecção do encoder no terminal da Quanser. Além disso, contém a contagem do encoder em uma volta, o modo de quadratura no qual ele vai operar e o campo ``.ENCODER_INITIAL_VALUE`` que especifica qual a contagem inicial do encoder desejada. Esse _script_ também inicializa os encoders com o modo de quadratura e a contagem inicial especificados.
* ``simulation.m``: _script_ contendo informações a respeito da simulação a ser realizada. A saber, o tempo de amostragem e a duração da simulação, assim como um vetor contendo todos os instantes de amostragem do início da simulação até o seu término. Esse _script_ é, via de regra, dispensável, mas trás uma maior conveniência.
* ``terminal.m``: contém a informação do tipo de terminal, podendo ser este do tipo 'q8_usb' ou 'q2_usb'. Também realiza a conecção do terminal da Quanser com o computador e armazena o _handle_ necessário para enviar e receber informações dele. Vale ressaltar que o número de conecções especificado deve estar de acordo com o tipo de terminal utilizado.
* ``load_setup.m``: esse é o _script_ mais importante do código, sendo ele responsável por carregar todas as informações dos demais _scripts_ supracitados e executar todas as ações de conecção. Além disso, ele carrega as funções das pastas ``read_write`` e ``rotary_servo`` (vide próximas secções). Recomenda-se que ele esteja no início de todo _script_ que for utilizar esse projeto ou ser executado na Janela de Comandos (Command Window) do MATLAB a fim de facilitar o uso das plantas de controle do laboratório.
* ``terminate.m``: zera o sinal de controle enviado pelas portas de "Analog Outputs" do terminal e, em seguida, encerra a conecção do terminal com o computador. É recomendado rodar esse _script_ logo após encerrar a simulação, seja em um _script_ ou na Janela de Comandos. É importante informar que, para a versão do Quarc 2.2, é gerado um erro ao tentar realizar a conecção com o terminal, algo que acontece quando se roda os _scripts_ ``terminal.m`` ou ``load_setup.m``, se ele já estiver conectado. É, pois, necessário, para essa versão, rodar o _script_ ``terminate.m`` ao fim de toda simulação, a fim de não gerar erro ao tentar realizar a simulação novamente. Caso não seja possível executar o ``terminate.m``, deve-se reiniciar o MATLAB.

&nbsp;&nbsp;&nbsp;&nbsp;As informações nos arquivos estão padronizadas para o uso no servo motor rotacional — com exceção do campo ``.CONNECTION`` que depende da montagem e que pode ter sido alterada desde a escrita deste documento.
