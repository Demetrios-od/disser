% clear

% открываем график
% open('../figures/deh/dcr_g1_025.fig')

% извлекаем указатели на линии
lh = flipud(get(gca, 'children'));
llh = length(lh);

% предположим, что все графики имеют одну шкалу по оси x.
% извлекаем координату x
x = get(lh(1), 'xdata');

% извлекаем координаты y и заносим их все в один массив
y = zeros(llh, length(x));
for i = 1:llh
  y(i,:) = get(lh(i), 'ydata');
end

% определяем, в какой строке массива y находится макс(мин) элементы.
% определять будем посередине строки
% [m, i] = max(y(:, round(length(x)/2)));     % или MIN
% теперь i - номер наивысшего (низшего) графика

lstyles = ['k- '; 'k--'; 'b- '; 'b--'; 'r- '; 'r--'; 'm- '; 'm--'];

% очищаем график
% clf
figure
% set(gcf, 'position', [490 50 600 570])
set(gcf, 'position', [754 76 351 255])

% рисуем оригинальные графики
% subplot(2, 1, 1)
% hold on
% for k = 1:llh
%   plot(x, y(k,:), lstyles(k,:))
% end
% grid on

% рисуем разностные графики
% subplot(2, 1, 2)
hold on
for k = 1:llh-1
  plot(x, y(k,:)-y(llh,:), lstyles(k,:), 'linewidth', 2)
end
grid on

% рисуем графики отношений
figure
set(gcf, 'position', [806 100 351 255])
hold on
for k = 1:llh-1
  plot(x, y(k,:)./y(llh,:), lstyles(k,:), 'linewidth', 2)
end
grid on
