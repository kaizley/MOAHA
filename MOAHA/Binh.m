function f=Binh(xx)
% Binh
x=xx';

y(1,:) = x(1,:).^2+x(2,:).^2;
y(2,:) = (x(1,:)-5).^2+(x(2,:)-5).^2;

f=y';
