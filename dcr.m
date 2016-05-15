function D = dcr(sig, tau, a, C)
% DCR Обобщённый D-критерий для селективного сигнала.
%
% Использование: dcr(sig, tau, a, C)
%   sig.fhandle - ссылка на элементарную селективную сигнальную функцию
%     (значения функции должны быть нормированы);
%   sig.polynom - образующий полином парциального сигала;
%   sig.params - параметры сигнальной функции (вектор-строка);
%   tau - смещение момента наблюдения, тактовых интервалов
%     от 0 до 1, по умолчанию 0;
%   a - амплитуда колебаний АЧХ в полосе (-wb, +wb), по умолчанию 0;
%   C - количество колебаний АЧХ в полосе (-wb, +wb), по умолчанию 0.

% (c) Бухан Д.Ю., 2010-2011

if nargin<3
  a = 0;
  C = 0;
end
if nargin==1
  tau = 0;
end

N = 30;
d = zeros(1, 2*N+1);
x1 = [-N:-1, find(sig.polynom==0)-1, (length(sig.polynom)+1):N];
for x=x1
  d(x+N+1) = abs(csig(sig, x-tau, a, C));
end
D = sum(d);
