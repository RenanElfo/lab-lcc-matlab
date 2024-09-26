# Manual de uso e Configuração deste Código

### Introdução:

&nbsp;&nbsp;&nbsp;&nbsp;Este código foi escrito para facilitar a utilização das plantas de controle no Laboratório de Controle por Computador sem que seja necessário utilizar o _Simulink_. Ele consiste de vários _scripts_ que, juntos, permitem conectar, medir e enviar sinais para as plantas utilizando os terminais da Quanser — por padrão, ele se conecta em um terminal 'q8_usb', mas também é possível especificar um terminal 'q2_usb' — de forma simplificada e abstraída.

## Utilização:
### Utilização Básica:



### Utilização Aprofundada:

&nbsp;&nbsp;&nbsp;&nbsp;Existem, neste código, sete _scripts_ que podem ser considerados os "principais". Eles são:
* ``analog_input.m``: contém as informações necessárias para a utilização dos _inputs_ analógicos do sistema. Esses inputs estão conectados na região do terminal onde está escrito "Analog Inputs". São exemplos de _inputs_ analógicos os potenciômetros, extensômetros e tacômetros. Cada tipo diferente de entrada analógica possui campos distintos com informações relevantes para o seu funcionamento, então cabe ao usuário conhecer ao menos os valores nominais. Recomenda-se que quaisquer outro tipo de _input_ analógico seja colocado nesse arquivo seguindo o padrão estilístico do código.
* ``controls.m``: contém as informações a respeito dos sinais de controle que serão enviados à planta pelo terminal. Possui dois campos apenas: ``.CONNECTION``, que guarda o canal de conexão do controle no terminal — na região onde se tem escrito "Analog Outputs"; e ``.MAX_CONTROl``, que é o valor máximo, em termos absolutos, do controle, a fim de fornecer uma maior segurança para os usuários do laboratório e proteger as plantas.
* ``encoders.m``:
* ``load_setup.m``:
* ``simulation.m``:
* ``terminal.m``:
* ``terminate.m``:

&nbsp;&nbsp;&nbsp;&nbsp;As informações nos arquivos estão padronizadas para o uso no servo motor rotacional — com exceção do campo ``.CONNECTION`` que depende da montagem e que pode ter sido alterada desde a escrita deste documento.
