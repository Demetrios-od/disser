% Визуализация N-параметрического сигнала и его спектра

alpha = 0.7;
x = [0.4 0.15 0.25 0.1 0.05 0];

% рисуем полученный спектр
clf
spectr_npar(alpha, x)
set(gcf, 'position', [7 37 560 257])
% set(gcf, 'menubar', 'none')
set(gcf, 'color', 'white')

% рисуем сигнал
figure
t = [-3:0.01:3];
sig.fhandle = @sel_npar;
sig.polynom = 1;
sig.params = [alpha, x];
plot(t, csig(sig, t, 0, 0))     % сам сигнал
% hold on
% plot(t, csig(sig, t, 0, 0).^2, 'r-')     % энергия сигнала
% title(['Es = ', num2str(fval), '%'])
grid on
set(gcf, 'position', [579 39 560 401])
% set(gcf, 'menubar', 'none')
set(gcf, 'color', 'white')
