function spectr_npar(alpha, x)
% рисование спектра N-параметрического селективного сигнала
N = length(x);
i = 1:N;
Xpr(i) = i*alpha/N;
Xpr(N+1) = Xpr(N);
X = [0, 1-fliplr(Xpr), 1, 1+Xpr];
Y = [1, 1, 1-fliplr(x), 0.5, x, 0];
line(X, Y)
grid on
