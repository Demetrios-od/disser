function isk_c()
% ISK_C Построение зависимости искажений от параметров АЧХ

% (c) Бухан Д.Ю., 2011

%----------------- Установка исходных данных -----------------
clc

% Сигналы
fhs = {@sel_stup, @sel_treug, @sel_lin2, @sel_2zv, ...
       @sel_si5, @sel_si1, @sel_sukzv, @sel_bspl, @sel_spl3, ...
       @sel_pripcos, @sel_si3, @sel_npar};

% Выбираем номера интересующих сигналов.
% Группа 1: № 1-4
% Группа 2: № 5-9
% Группа 3: № 10-11
% N-параметрический: № 12
fhandles = fhs([2]);
N = 10;     % Число параметров N-параметрического сигнала (№ 12)

% Стили линий на графике
lstyles = ['k- '; 'k--'; 'b- '; 'b--'; 'r- '; 'r--'; 'm- '; 'm--'];
if size(lstyles, 1) < length(fhandles)
  error('Необходимо задать больше стилей оформления линий');
end

% funname - указатель на вызываемую функцию. Поддерживаются
%           следующие функции:
%   @dcr - обобщённый D-критерий;
%   @ecr - обобщённый Е-критерий;
%   @hor - горизонтальный раскрыв глаз-диаграммы (прямой метод);
%   @hor2 - горизонтальный раскрыв глаз-диаграммы (улучшенный метод);
%   @oke - относительная концентрация энергии в главном лепестке.
funname = @dcr;

tau = 0;   % Для D и E критериев: сдвиг момента взятия отчёта.
           % Для горизонтального раскрыва: уровень измерения
           %   ширины глаз-диаграммы.
           % Для концентрации энергии: количество лепестков
           %   в основной части сигнала.

s_pol = [1 1];     % полином
a = 0;             % коэффициент скругления спектра
a1 = 0.1;          % неравномерность АЧХ
C = 0:0.02:6;      % число волн АЧХ в полосе сигнала

%------------------------ начинается расчёт ------------------------

% cla    % поставить в комментарий, если надо дорисовывать графики
hold on
for j = 1:length(fhandles)
  y = zeros(1, length(tau));
  s_fh = fhandles{j};
  disp(strcat('Рассчитывается зависимость для функции:',...
    func2str(s_fh)))
  calcmode = 1;     % требуется оптимизация
  switch func2str(s_fh)     % задаём исходные данные
    case 'sel_lin2'
      s_pars = 0.5;
      LLim = 0;
      ULim = 1;
    case 'sel_2zv'
      s_pars = [0.5 0.5];
      LLim = [0 0];
      ULim = [1 1];
    case 'sel_spl3'
      s_pars = [-1 -3];
      LLim = [-5.7 -8.5];
      ULim = [4.2 0];
    case 'sel_npar'
      s_pars = 0.5*ones(1, N);
      LLim = zeros(1, N);
      ULim = ones(1,N);
    otherwise
      calcmode = 2;
  end
  if calcmode == 1     % выполняем оптимизацию по дополнительным параметрам
    optpars = s_pars;
    for i = 1:length(C)
      disp(strcat('Обрабатывается точка C=', num2str(C(i), 3)))
      % включить условие, если в качестве начальной точки будет
      % использоваться не текущая, а заданная выше
      % if mod(C(i), 0.1) == 0
      %   optpars = s_pars;
      % end
      [optpars, y(i)] = neldercon(@vspom, optpars, LLim, ULim, a,...
        s_pol, s_fh, tau, funname, a1, C(i));
    end
  else     % оптимизация не требуется
    for i = 1:length(C)
      % disp(strcat('Обрабатывается точка C=', num2str(C(i), 2)))
      y(i) = vspom([], a, s_pol, s_fh, tau, funname, a1, C(i));
    end
  end
  % если функцию максимизировали, то инвертируем значения
  strf = func2str(funname);
  if ~(strcmpi(strf, 'dcr') || strcmpi(strf, 'ecr'))
    y = 1-y;
  end
  plot(C, y, lstyles(j,:), 'linewidth', 2)
end
hold off
grid on
set(gcf, 'position', [716 62 351 255])

extr_fig_data     % рисуем разностные графики с последней функцией

load chirp
sound(y, fs)
end


function de = vspom(s_pars, a, s_pol, s_fh, tau, funname, a1, C)
sig.fhandle = s_fh;
sig.polynom = s_pol;
sig.params = [a, s_pars];
de = feval(funname, sig, tau, a1, C);     % это если функцию надо минимизировать
% если функцию надо максимизировать, то инвертируем значения
strf = func2str(funname);
if ~(strcmpi(strf, 'dcr') || strcmpi(strf, 'ecr'))
  de = 1-de;
end
end
