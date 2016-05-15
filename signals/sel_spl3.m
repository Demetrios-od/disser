function s = sel_spl3(x,p)
% Для Стрелковской: обычный сплайн (три параметра).
% p(1) => alpha
% p(2) => ro
% p(3) => gamma

s = ones(size(x));
i = find(x);

if p(1)==0
  p(1) = 0.001;
end

z(i) = p(1)*pi*x(i);
s(i) = (2*sinc(x(i))./z(i).^2).*...
  ((6*(1+p(2)+p(3))-p(3)*z(i).^2).*sinc(p(1)*x(i))-...
  (3+2*p(2)+4*p(3))*cos(z(i)) - 3-4*p(2)-2*p(3));
