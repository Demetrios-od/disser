function [XL, FL, iter, fcalls] = neldercon(fhandle, x0, LLim, ULim, varargin)
% NELDERCON Поиск минимума функции по методу Недлера-Мида с явными
% ограничениями.
%
% Использование: [x, fval, iter, fcalls] = neldercon(fhandle, x0, LLim, ULim, P1, P2,...)
%   Входные параметры:
%     fhandle - указатель на целевую функцию;
%     x0 - начальная точка;
%     LLim - массив нижних значений ограничений переменных;
%     ULim - массив верхних значений ограничений переменных;
%     P1, P2... - дополнительные параметры, передаваемые в функцию @fhandle.
%   Выходные параметры:
%     x - полученная точка минимума;
%     fval - значение целевой функции в точке минимума;
%     iter - число итераций;
%     fcalls - число вызовов целевой функции.

% (c) Бухан Д.Ю., 2010

% константы для расчётов
alfa = 1.3;       % коэффициент отражения
epsd = 0.001;     % максимально допустимое расстояние между точками комплекса
n = length(x0);   % размерность пространства
maxiters = 5000;  % максимальное число итераций (средство от зависания)
shstep = 100;     % выполнение каждой такой итерации выводится на экран
ksize = 0.25;     % размер уменьшенного комплекса (0 < ksize <= 1)
showprocess = false;   % показывать ход вычислений

if satconds(x0, LLim, ULim) > 0
  error('Начальная точка не удовлетворяет ограничениям');
end

% Определяем точки комплекса и рассчитываем значения функции.
% Строка матрицы x представляет одну точку
x = zeros(2*n, n);
f = zeros(2*n, 1);
x(1,:) = x0;
f(1) = feval(fhandle, x0, varargin{:});
fcalls = 1;
for i = 2:2*n     % перебираем точки комплекса
  for j = 1:n     % перебираем координаты выбранной точки
    % x(i,j) = LLim(j)+rand*(Ulim(j)-LLim(j));     % обычный комплекс
    % комплекс в окрестности стартовой точки
    ars = Ulim(j)-LLim(j);     % область допустимых значений
    x(i,j) = LLim(j)+ars/2+(rand-0.5)*ksize*ars;
  end
  f(i) = feval(fhandle, x(i,:), varargin{:});
end
fcalls = fcalls + 2*n-1;

% Начинается итерационный процесс
if showprocess
  disp('Оптимизация началась')
end
iter = 0;
finprocess = false;

while ~finprocess     % главный цикл
  iter = iter+1;
  if iter > maxiters
    disp('Превышено допустимое число итераций')
    break
  end

  if showprocess && (mod(iter, shstep) == 0)
    disp(strcat('Итерация_', int2str(iter)))
  end

  % рисуем летающие шарики
  % cla
  % xp = x(:,1);
  % yp = x(:,2);
  % plot(xp, yp, 'bo')
  % grid on
  % set(gca, 'XLim', [LLim(1), ULim(1)])
  % set(gca, 'YLim', [LLim(2), ULim(2)])
  % title(int2str(iter))
  % pause(0.1)

  % находими минимальное и максимальное значения функции
  % и соответствующие им точки
  [FH XHpos] = max(f);
  XH = x(XHpos,:);

  % находим центр тяжести всех точек, кроме XH
  X0 = (sum(x)-XH)/(2*n-1);

  % находим значение функции в центре тяжести
  F0 = feval(fhandle, X0, varargin{:});
  fcalls = fcalls+1;

  if F0 > FH
    % уменьшаем размер комплекса относительно точки XL
    % и рассчитываем значения функции в каждой точке, кроме XL
    if showprocess
      disp(strcat('Уменьшаем размер комплекса на итерации_', int2str(iter)))
    end
    [FL XLpos] = min(f);
    XL = x(XLpos,:);
    for i = 1:2*n
      if i~=XLpos
        x(i,:) = (x(i,:)+XL)/2;
        f(i) = feval(fhandle, x(i,:), varargin{:});
      end
    end
    fcalls = fcalls + 2*n-1;
    continue
  end

  % отражаем точку XH относительно точки X0 и получаем точку XR
  XR = (1+alfa)*X0-alfa*XH;

  % приводим точку XR в допустимую область
  [cod, pos] = satconds(XR, LLim, ULim);
  if cod==1
    XR(pos) = LLim(pos)+1e-6*(ULim(pos)-LLim(pos));
  end
  [cod, pos] = satconds(XR, LLim, ULim);
  if cod==2
    XR(pos) = ULim(pos)-1e-6*(ULim(pos)-LLim(pos));
  end
  if satconds(XR, LLim, ULim) > 0
    error('Непонятное событие');
  end

  % вычисляем значение функции в точке XR
  FR = feval(fhandle, XR, varargin{:});
  fcalls = fcalls+1;

  iter2 = 0;
  while FR > FH
    iter2 = iter2+1;
    % смещаем точку XR ближе к X0
    % disp('Смещаем точку XR ближе к X0')
    XR = (XR+X0)/2;
    FR = feval(fhandle, XR, varargin{:});
    fcalls = fcalls+1;
    if iter2 > 10
      warning(strcat('Внутренний цикл завис на итерации_', int2str(iter)))
      finprocess = true;
      break
    end
  end

  % заменяем точку XH на XR
  % disp('Заменяем точку XH на XR')
  x(XHpos,:) = XR;
  f(XHpos) = FR;

  % проверяем сходимость
  % sig2 = (sum(f.^2)-(sum(f))^2/(2*n))/(2*n);
  sx = shodimost(x);
  if sx < epsd
    if showprocess
      disp('Достигнуто минимальное расстояние между точками комплекса')
    end
    finprocess = true;
  end
end     % главного цикла

if showprocess
  disp(strcat('Оптимизация закончена за_', int2str(iter), '_итераций'))
end
[FL XLpos] = min(f);
XL = x(XLpos);

end

%------------- Вспомогательные функции -------------

function [cod, pos] = satconds(x, LLim, ULim)
% Определяет, находится ли точка x в допустимых пределах,
% и возвращает код ошибки
c1 = (x-LLim) < 0;
c2 = (ULim-x) < 0;
if any(c1)     % если x < LLim
  cod = 1;
  pos = find(c1);
elseif any(c2)     % если x > ULim
  cod = 2;
  pos = find(c2);
else
  cod = 0;     % точка является допустимой
  pos = [];
end

end


function dmax = shodimost(x)
% определяет сходимость как максимальное расстояние между
% точками комплекса
dmax = sqrt(sum((x(1,:)-x(2,:)).^2));
for i = 1:size(x, 1)
  for j = 1:i-1
    d = sqrt(sum((x(i,:)-x(j,:)).^2));
    if d > dmax
      dmax = d;
    end
  end
end
