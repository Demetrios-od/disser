function hd = hor(sig, mlv, N0, a, C)
% HOR Расчёт горизонтального раскрыва глаз-диаграммы.
%
% ВНИМАНИЕ: программа НЕ обрабатывает парциальные сигналы с искажениями!
%           (кроме сигналов без постоянной составляющей, например
%           класс 4).
%
% Использование: hor(sig, mlv, a, C)
%   sig.fhandle - ссылка на элементарную сигнальную функцию;
%   sig.polynom - образующий полином парциального сигнала;
%   sig.params - параметры сигнальной функции (params(1)=alpha,
%     params(2)=beta и т.д.);
%   mlv - уровень, на котором измеряется ширина горизонтального раскрыва
%     (по умолчанию - 0);
%   N0 - СПМ белого шума, накладываемого на сигнал (по умолчанию 0);
%   a - амплитуда косинусоиды, аппроксимирующей АЧХ (по умолчанию - 0);
%   C - число полуволн косинусоиды, аппроксимирующей АЧХ (по умолчанию - 0).

% (c) Бухан Д.Ю., 2009-2014

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

% Вычисления
ssh = 7;     % длина учитываемого "хвоста" функции
ct = 20;     % количество точек на одном графике
hor = ct;
% smid = mlv + a/2;
smid = mlv;

% Расчет или загрузка ПСП
psp_size = 300;    % длина псевдослучайной последовательности
%psp = 2*round(rand(1, psp_size))-1;
load psp300nrz;

sn = csig(sig, -ssh:1/ct:ssh+1, a, C);
% создаем реализацию гауссовского шума
% надо преобразовать СПМ шума N0 в его амплитуду NA
NA = sqrt(N0*pi*(1+sig.params(1)));
for x = ssh:psp_size-ssh
  ss = NA*randn(1, 2*ct+1);
  for k = 1:2*ssh
    p = (k-1)*ct+1:(k+1)*ct+1;
    ss = ss + sn(p)*psp(k+x-ssh);
  end
  m = ct;
  sw = false;
  if (ss(1)>smid) && ((ss(ct)<smid) || (ss(round(ct/2))<smid))
    m = find(ss<smid);
    sw = true;
  elseif (ss(1)<smid) && ((ss(ct)>smid) || (ss(round(ct/2))>smid))
    m = find(ss>smid);
    sw = true;
  end
  if sw
    m = m(1);
    m = m-1+abs(ss(m-1)-smid)/abs(ss(m-1)-ss(m));
  end
  if m<hor
    hor = m;
  end
  % round(100*(x-ssh)/(psp_size-2*ssh))    % сколько процентов выполнено
end

hd = 2*(hor-1)/ct;     % значение функции - величина горизонтального раскрыва
