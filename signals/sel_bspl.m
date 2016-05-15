function s = sel_bspl(x,p)
% Для Стрелковской: В-сплайн. Получен в работе [77]
% p(1) => alpha

s = ones(size(x));
i = find(x);

if p(1)==0
  p(1) = 0.001;
end

s(i) = (12*sinc(x(i))./(p(1)*pi*x(i)).^2).*...
  (2*sinc(p(1)*x(i)/2)-sinc(p(1)*x(i))-1);
