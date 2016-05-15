function s = sel_si3(x,p)
% Сигнал № 3, предложенный Сукачёвым и Ильиным в [66]
% p(1) => alpha

s = ones(size(x));
i = find(x);

s(i) = sinc(x(i)).*((cos(p(1)*pi*x(i)/2)).^2)./(1-(p(1)*x(i)).^2);
