function s = sel_stup(x,p)
% Сигнал со ступенчатым срезом спектра
% p(1) => alpha

s = sinc(x).*cos(p(1)*pi*x);
