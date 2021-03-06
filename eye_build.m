%  ПОСТРОЕНИЕ  ГЛАЗ-ДИАГРАММЫ

% Имя селективной сигнальной функции
sig.fhandle = @sel_pripcos;

% Образующий полином парциального сигнала. Для селективного сигнала
% полином равен 1
sig.polynom = [1];

% параметры сигнальной функции (альфа, бета, и т.п.)
sig.params = 0.35;

% уровень, на котором происходит измерение горизонтального раскрыва
mlv = 0;

% спектральная плотность мощности белого шума
N0 = 0;

% ИСКАЖЕНИЯ
% амплитуда косинусоиды, аппроксимирующей АЧХ канала связи
a = 0;

% число полуволн косинусоиды, аппроксимирующей АЧХ канада связи
% в полосе (-wb, wb)
C = 0;

% Отношение скорости передачи к скорости Найквиста
es = 1.03;

% вызываем функцию построения глаз-диаграммы и передаем ей все параметры
eye_diag(sig, mlv, N0, a, C, es)
%hor3(sig, mlv, N0, a, C)