function s = sel_si1(x,p)
% Сигнал № 1, предложенный Сукачёвым и Ильиным в [66]
% p(1) => alpha

s = ones(size(x));
i = find(x);

if p(1)==0
  p(1) = 0.001;
end

s(i) = 2*sinc(x(i)).*(1-cos(p(1)*pi*x(i)))./(p(1)*pi*x(i)).^2;
