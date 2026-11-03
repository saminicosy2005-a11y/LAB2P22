
%% PARTE B
% =========================================================
% PARTE 1: RECONSTRUCCION DE LA ONDA CUADRADA
% =========================================================

clear; clc; close all;

% Parametros de la señal
T = 2;                  % Periodo de la señal [s]
w0 = 2*pi/T;            % Frecuencia angular fundamental [rad/s]
t = linspace(0, 6, 3000); % Vector de tiempo para graficar tres periodos

% Generacion de la señal cuadrada original:
% La señal toma el valor 2 durante el primer segundo de cada periodo
% y el valor 0 durante el segundo restante.
x = 2*(mod(t,T) < 1);

% Cantidad de armonicos que se utilizaran en cada reconstruccion
Nvalores = [3, 10, 50];

% Creacion de una figura para mostrar las tres reconstrucciones
figure;

for p = 1:length(Nvalores)

    % Seleccion del numero de armonicos para cada reconstruccion
    N = Nvalores(p);

    % Inicializacion de la señal reconstruida
    x_rec = zeros(size(t));

    % Reconstruccion mediante la Serie de Fourier compleja:
    % Se consideran los indices desde -N hasta N,
    % incluyendo armonicos positivos, negativos y el componente DC.
    for k = -N:N

        % Calculo de los coeficientes complejos de Fourier
        if k == 0
            % Componente de corriente continua (DC)
            ak = 1;
        else
            % Coeficientes de Fourier de la onda cuadrada
            ak = (1 - (-1)^k)/(1j*k*pi);
        end

        % Suma de cada componente armonica a la señal reconstruida
        x_rec = x_rec + ak*exp(1j*k*w0*t);
    end

    % Representacion de la señal original y reconstruida
    subplot(3,1,p);
    plot(t, x, 'k', 'LineWidth', 1.5);
    hold on;
    plot(t, real(x_rec), 'r', 'LineWidth', 1.1);

    % Configuracion de las graficas
    grid on;
    xlim([0 6]);
    ylim([-0.5 2.5]);
    xlabel('Tiempo t (s)');
    ylabel('x(t)');
    title(['Reconstrucción con N = ', num2str(N)]);
    legend('Señal original', 'Serie de Fourier');
end


% =========================================================
% PARTE 2: ESPECTRO DE COEFICIENTES
% EJERCICIOS 1 Y 2
% =========================================================

% Definicion de los indices de frecuencia para el analisis
% Se consideran los coeficientes desde k = -5 hasta k = 5.
k = -5:5;

% Parametros de la señal
T = 2;
w0 = 2*pi/T;


% =========================================================
% EJERCICIO 1: ONDA CUADRADA
% CALCULO NUMERICO MEDIANTE INTEGRACION
% ======================================================

% Inicializacion del vector de coeficientes numericos
a1_num = zeros(size(k));

for n = 1:length(k)

    % Integral de la señal entre 0 y 1:
    % En este intervalo x(t) = 2.
    I1 = integral(@(t) 2.*exp(-1j*k(n)*w0.*t), 0, 1);

    % Integral entre 1 y 2:
    % En este intervalo la señal vale cero.
    I2 = 0;

    % Calculo del coeficiente complejo de Fourier:
    % Se divide la integral de un periodo para T.
    a1_num(n) = (I1 + I2)/T;

end


% ======================================================
% EJERCICIO 2: EXPONENCIAL PERIODICA
% CALCULO NUMERICO MEDIANTE INTEGRACION
% ======================================================

% Inicializacion del vector de coeficientes numericos
a2_num = zeros(size(k));

for n = 1:length(k)

    % Definicion del integrando:
    % x(t) = exp(-t), multiplicada por la exponencial compleja.
    integrando = @(t) exp(-t).*exp(-1j*k(n)*w0.*t);

    % Integracion en un periodo de la señal: [-1,1].
    I = integral(integrando, -1, 1);

    % Calculo del coeficiente complejo de Fourier:
    % Se normaliza la integral dividiendo para el periodo T.
    a2_num(n) = I/T;

end


% ======================================================
% CALCULO DE MODULOS Y FASES
% ======================================================

% Calculo de la magnitud de los coeficientes complejos
mag1 = abs(a1_num);
mag2 = abs(a2_num);

% Calculo de la fase de los coeficientes en radianes
fase1 = angle(a1_num);
fase2 = angle(a2_num);

% Definicion de una tolerancia para eliminar residuos
% numericos muy pequeños que deberian ser iguales a cero.
tol = 1e-10;

% Correccion de los coeficientes cercanos a cero
a1_num(abs(a1_num) < tol) = 0;
a2_num(abs(a2_num) < tol) = 0;

% Actualizacion de las magnitudes y fases despues
% de corregir los residuos numericos.
mag1 = abs(a1_num);
mag2 = abs(a2_num);

fase1 = angle(a1_num);
fase2 = angle(a2_num);

% La fase de un coeficiente igual a cero no esta definida.
% Por ello, se representa mediante NaN.
fase1(mag1 < tol) = NaN;
fase2(mag2 < tol) = NaN;


% =====================================================
% TABLAS DE RESULTADOS NUMERICOS
% ======================================================

% Presentacion de los coeficientes, magnitudes y fases
% calculados numericamente para cada ejercicio.

disp('==============================================');
disp('EJERCICIO 1: RESULTADOS NUMERICOS');
disp('==============================================');

tabla1 = table(k.', a1_num.', mag1.', fase1.', ...
    'VariableNames', {'k','Coeficiente','Modulo','Fase_rad'});

disp(tabla1);

disp('==============================================');
disp('EJERCICIO 2: RESULTADOS NUMERICOS');
disp('==============================================');

tabla2 = table(k.', a2_num.', mag2.', fase2.', ...
    'VariableNames', {'k','Coeficiente','Modulo','Fase_rad'});

disp(tabla2);


% ======================================================
% GRAFICAS DE MAGNITUD Y FASE CON STEM
% ======================================================

% Representacion discreta de los espectros de magnitud y fase
% para los dos primeros ejercicios.
% La funcion stem() permite visualizar cada coeficiente
% en funcion de su indice de frecuencia k.

figure;

% Espectro de magnitud del Ejercicio 1
subplot(2,2,1);
stem(k, mag1, 'filled');
grid on;
title('Ejercicio 1: Magnitud numerica');
xlabel('Indice k');
ylabel('|a_k|');
xticks(k);

% Espectro de fase del Ejercicio 1
subplot(2,2,2);
stem(k, fase1, 'filled');
grid on;
title('Ejercicio 1: Fase numerica');
xlabel('Indice k');
ylabel('Fase [rad]');
xticks(k);

% Espectro de magnitud del Ejercicio 2
subplot(2,2,3);
stem(k, mag2, 'filled');
grid on;
title('Ejercicio 2: Magnitud numerica');
xlabel('Indice k');
ylabel('|a_k|');
xticks(k);

% Espectro de fase del Ejercicio 2
subplot(2,2,4);
stem(k, fase2, 'filled');
grid on;
title('Ejercicio 2: Fase numerica');
xlabel('Indice k');
ylabel('Fase [rad]');
xticks(k);

% Titulo general de la figura
sgtitle('Espectros obtenidos mediante integracion numerica');



% =========================================================
% PARTE 3: VERIFICACION DE LA DTFS MEDIANTE FFT
% EJERCICIO 3
% =========================================================

% Definicion del numero de muestras por periodo
N = 7;

% Indices de frecuencia de los coeficientes DTFS
% MATLAB devuelve los coeficientes desde k = 0 hasta k = N-1.
k = 0:N-1;

% Definicion de un periodo de la señal discreta:
% x[n] = 1 para n = 0, 1, 2.
% x[n] = 0 para n = 3, 4, 5, 6.
x = [1 1 1 0 0 0 0];


% =====================================================
% CALCULO DE COEFICIENTES MEDIANTE FFT
% =====================================================

% Aplicacion de la Transformada Discreta de Fourier (FFT).
% Se divide para N para obtener los coeficientes
% de la Serie de Fourier Discreta (DTFS).
ak = fft(x)/N;


% =====================================================
% CALCULO DE MODULOS Y FASES
% =====================================================

% Magnitud de los coeficientes complejos DTFS
modulo = abs(ak);

% Fase de los coeficientes complejos en radianes
fase = angle(ak);


% =====================================================
% TABLA DE RESULTADOS
% =====================================================

% Organizacion de los indices, magnitudes y fases
% obtenidos mediante la funcion fft().

tabla = table(k.', modulo.', fase.', ...
    'VariableNames', {'k','Modulo','Fase_rad'});

disp('RESULTADOS DTFS MEDIANTE FFT');
disp(tabla);


% =====================================================
% GRAFICAS DE MAGNITUD Y FASE
% =====================================================

% Representacion de los coeficientes DTFS obtenidos
% mediante FFT utilizando la funcion stem().

figure;

% Espectro de magnitud de la DTFS
subplot(2,1,1);
stem(k, modulo, 'filled');
grid on;
xlabel('Indice k');
ylabel('|a_k|');
title('Magnitud de los coeficientes DTFS');
xticks(k);

% Espectro de fase de la DTFS
subplot(2,1,2);
stem(k, fase, 'filled');
grid on;
xlabel('Indice k');
ylabel('Fase [rad]');
title('Fase de los coeficientes DTFS');
xticks(k);

% Titulo general de la figura
sgtitle('Espectro DTFS obtenido mediante FFT');



