function s = sel_pripcos(x,p)
% Сигнал со спектром типа "приподнятый косинус"
% p(1) => alpha

s = ones(size(x));
i = find(x);

if p(1)==1
  p(1) = 0.999;
end

s(i) = sinc(x(i)).*(cos(p(1)*pi*x(i))./(1-(2*p(1)*x(i)).^2));
j = find(abs(s)>1000);
s(j) = 0;
