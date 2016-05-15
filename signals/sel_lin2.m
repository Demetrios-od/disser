function s = sel_lin2(x,p)
% Линейная интерполяция (два параметра)
% Сигнал предложен Сукачёвым Э.А. в публикации [52]
% p(1) => alpha
% p(2) => beta

s = ones(size(x));
i = find(x);

s(i) = sinc(x(i)).*(2*p(2)*cos(p(1)*pi*x(i))-(2*p(2)-1)*sinc(p(1)*x(i)));
