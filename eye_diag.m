function eye_diag(sig, mlv, N0, a, C, es)
% EYE_DIAG Построение глаз-диаграммы парциального сигнала.
%
% Использование: eye_diag2(sig, mlv, N0, a, C)
%   sig - структура, описывающая сигнал (обязательный параметр).
%       Имеет следующие поля:
%     sig.fhandle - ссылка на сигнальную функцию;
%     sig.polynom - образующий полином парциального сигнала;
%     sig.params - параметры сигнальной функции (params(1) = alpha,
%       params(2) = beta и т.д.);
%   mlv - уровень, на котором измеряется ширина горизонтального раскрыва
%     (по умолчанию 0);
%   N0 - СПМ белого шума, накладываемого на сигнал (по умолчанию 0);
%   a - амплитуда косинусоиды, аппроксимирующей АЧХ (по умолчанию 0);
%   C - число полуволн косинусоиды, аппроксимирующей АЧХ (по умолчанию 0);
%   es - отношение скорости передачи к скорости Найквиста (по умолчанию 1).

% (c) Бухан Д.Ю., 2004-2014

% Проверка входных парметров
if nargin < 6
    es = 1;
end
if nargin < 5
  a = 0;
  C = 0;
end
if nargin < 3
  N0 = 0;
end
if nargin == 1
  mlv = 0;
end
cla
hold on

% Вычисления
ssh = 7;     % длина учитываемого "хвоста" функции
ct = 20;     % количество точек на одном графике
hor = ct;
% smid = mlv + a/2;
smid = mlv;

% Расчет или загрузка ПСП
%psp_size = 14;    % длина псевдослучайной последовательности
%psp = 2*round(rand(1, psp_size))-1;
%psp = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
load psp300nrz;

sn = csig(sig, (-ssh:1/ct:ssh+1)/es, a, C);
% создаем реализацию гауссовского шума
% надо преобразовать СПМ шума N0 в его амплитуду NA
NA = sqrt(N0*pi*(1+sig.params(1)));
for x = ssh:psp_size-ssh
  ss = NA*randn(1, 2*ct+1);
  for k = 1:2*ssh
    p = (k-1)*ct+1:(k+1)*ct+1;
    ss = ss + sn(p)*psp(k+x-ssh);
  end
  plot(ss);
  % pause(0.2)
  % определяем горизонтальный раскрыв
  m = ct;
  sw = false;
  if (ss(1) > smid) && ((ss(ct+1) < smid) || (ss(round((ct+1)/2)) < smid))
    m = find(ss < smid);
    sw = true;
  elseif (ss(1) < smid) && ((ss(ct+1) > smid) || (ss(round((ct+1)/2)) > smid))
    m = find(ss > smid);
    sw = true;
  end
  if sw
    m = m(1);
    m = m - 1 + abs(ss(m-1)-smid)/abs(ss(m-1)-ss(m));
  end
  if m < hor
    hor = m;
  end
end

hor = 2*(hor-1)/ct;
% Выведем на график величину горизонтального раскрыва
title(['H = ', num2str(hor)])

% оформляем график
YT = -5:5;
for i = 1:length(YT)
  YTLc{i} = YT(i);
end
XTLc{1} = '-T';
XTLc{2} = '0';
XTLc{3} = 'T';

set(gcf, 'color', 'white')
set(gca, 'box', 'on', 'YTick', YT, 'YTickLabel', YTLc, 'YGrid', 'on', ...
  'XTick', [1, ct+1, 2*ct+1], 'XTickLabel', XTLc, 'XGrid', 'off', ...
  'XLim', [1, 2*ct+1])
% set(gca, 'YLim', [-0.5 1.5])
