function s = sel_npar(x,p)
% Интерполяция N-элементным линейным сплайном
% p(1) => alpha

S = [0.5 p(2:end)];
N = length(S)-1;
z = p(1)*pi*x/(2*N);
summa = zeros(size(x));
for k=0:N-1
  summa = summa + (S(k+2)-S(k+1)).*cos((2*k+1)*z).*(sinc(z/pi)-cos(z))+...
    (S(k+2)+S(k+1)).*sin(z).*sin((2*k+1)*z);
end
s = sinc(x).*(1-2*summa);
