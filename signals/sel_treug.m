function s = sel_treug(x,p)
% Сигнал с линейным срезом спектра
% p(1) => alpha

s = sinc(x).*sinc(p(1)*x);
