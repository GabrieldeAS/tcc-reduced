figure (1)
m=7;
n=8;
d=rand(m,n)
[x,y]=meshgrid(1:n,1:m);
plot3(x,y,d);grid on;
%figure (2)
%m = 2;
%n = 3;
%d = [1,1,1;2,2,2;3,3,3];