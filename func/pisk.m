function te1 = pisk(sig, n, a, C)
% PISK Максимально возможное увеличение ОСШ селективного сигнала.
%
% Использование: pisk(sig, n, a, C)
%   sig.fhandle - ссылка на элементарную селективную сигнальную функцию
%     (значения функции должны быть нормированы);
%   sig.polynom - образующий полином парциального сигнала;
%   sig.params - параметры сигнальной функции (вектор-строка);
%   n - не имеет значения, присутствует для совместимости с
%     программой FUN_A;
%   a - амплитуда колебаний АЧХ в полосе (-wb, +wb), по умолчанию 0;
%   C - количество колебаний АЧХ в полосе (-wb, +wb), по умолчанию 0.

% (c) Бухан Д.Ю., 2011

if length(sig.polynom)~=1
  error('Функция PISK не может обрабатывать парциальные сигналы.');
end
if nargin<3
  a = 0;
  C = 0;
end

% Внимание - ГЛЮК!!!
% В среде Matlab 7.5 функция quadl сортирует по алфавиту переменные,
% извлеченные из inline-функции, а потом присваивает значения
% согласно порядка своих аргументов. Поэтому обязательная переменная
% "x" должна быть первая по алфавиту среди других переменных
% внутри inline-функции. Необходимо также строго следить за именами
% других переменных.

s = strcat('csig(zsig,x,', num2str(a), ',', num2str(C), ').^2');

% для некоторых сигналов есть отдельная формула расчёта полной энергии
switch func2str(sig.fhandle)     % выбираем формулу
  case 'sel_npar'
    intg0 = e_npar(sig.params(1), sig.params(2:end));
  case 'sel_spl3'
    intg0 = e_spl3(sig.params(1), sig.params(2:end));
  case 'sel_lin2'
    intg0 = e_lin2(sig.params(1), sig.params(2:end));
  case 'sel_2zv'
    intg0 = e_2zv(sig.params(1), sig.params(2:end));
  case 'sel_stup'
    intg0 = e_stup(sig.params(1));
  case 'sel_si5'
    intg0 = e_si5(sig.params(1));
  case 'sel_treug'
    intg0 = e_treug(sig.params(1));
  case 'sel_pripcos'
    intg0 = e_pripcos(sig.params(1));
  case 'sel_si3'
    intg0 = e_si3(sig.params(1));
  case 'sel_si1'
    intg0 = e_si1(sig.params(1));
  case 'sel_sukzv'
    intg0 = e_sukzv(sig.params(1));
  case 'sel_bspl'
    intg0 = e_bspl(sig.params(1));
  otherwise
    nmax = 10;     % эта длина сигнала принимается за бесконечность
    intg0 = quadl(s, -nmax, nmax, [], [], sig);
end

te1 = intg0*(1+sig.params(1));
