%% Matrizes de movimento do Braço


%% Setup
clc;

clear;
%syms x y z theta phi psi;

x = -204.6119;
y = 0;
z = 20.3619;
theta = 0;
phi = pi;
psi = pi;
%% Dimensões do braço -- Segundo o modelo do TCC do Werley

h1 = 0;
a1 = 46.6;
a2 = 105.8;
a3 = 0.1;
a4 = 0;
a5 = 129.8;
a6 = 0;
a7 = 101.05;


%% Parametrização
M = [ 	cos(phi)*cos(psi)-sin(phi)*cos(theta)*sin(psi)  -cos(phi)*sin(psi)-sin(phi)*cos(theta)*cos(psi)     sin(phi)*sin(theta)     x
        sin(phi)*cos(psi)+cos(phi)*cos(theta)*sin(psi)  -sin(phi)*sin(psi)+cos(phi)*cos(theta)*cos(psi)     -cos(phi)*sin(theta)    y
        -sin(theta)*sin(psi)                            sin(theta)*cos(psi)                                 cos(theta)              z
        0                                               0                                                   0                       1];

ux = M(1,1);
uy = M(2,1);
uz = M(3,1);
vx = M(1,2);
vy = M(2,2);
vz = M(3,2);
wx = M(1,3);
wy = M(2,3);
wz = M(3,3);

Q1 = atan2(vx*(a6+a7)-x, y - vy*(a6+a7));

k1 = -x*sin(Q1) + y*cos(Q1) - a1 - (a6+a7)*(vy*cos(Q1)-vx*sin(Q1));
k2 = z - h1 + vz*(a6+a7);
k = ((a4+a5)^2 - a2^2 + a3^2 -(k1^2+k2^2))/(-2*a2);
A = k1^2 + k2^2;
B = -2*k*k2;
C = k^2-k1^2;

Q2 = atan2((-B + sqrt(B^2 - 4*A*C))/(2*A*C) , k2*(-B + sqrt(B^2 - 4*A*C))/2*A*C-k);

M = k1*cos(Q2) + k2*sin(Q2);
N = k1*sin(Q2) + k2*cos(Q2) - a2;

Q3 = atan2(((a4+a5)*(N*a3 + M*(a4+a5))/(a3^2 + (a4 + a5)^2) - M), ... %/a3
            (N*a3 + M*(a4+a5))/(a3^2 + (a4+a5)^2) );
Q4 = atan2(vx*cos(Q1) + vy*sin(Q1), ...
     vx*sin(Q1)*sin(Q2+Q3) + vy*sin(Q1)*cos(Q2+Q3) + vy*sin(Q1)*cos(Q2+Q3) + vz*cos(Q2+Q3));

sq5 = (cos(Q1)*sin(Q4) - sin(Q1)*cos(Q4)*sin(Q2+Q3))*vx +...
       (sin(Q1)*sin(Q4) - cos(Q1)*cos(Q4)*sin(Q2+Q3))*vy + (cos(Q4)*cos(Q2+Q3))*vz;

cq5 = -sin(Q1)*cos(Q3-Q2)*vx + cos(Q1)*cos(Q2+Q3)*vy + sin(Q2+Q3)*vz;

Q5 = atan2(sq5,cq5);

sq6 = (cos(Q1)*cos(Q4) - sin(Q1)*sin(Q4)*sin(Q2+Q3))*wx +...
    (sin(Q1)*cos(Q4) - cos(Q1)*sin(Q4)*sin(Q2 + Q3))*wy + (sin(Q4)*cos(Q3 - Q2))*wz;

cq6 =  (cos(Q1)*cos(Q4) - sin(Q1)*sin(Q4)*sin(Q3 - Q2))*ux + ...
    (sin(Q1)*cos(Q4) + cos(Q1)*sin(Q4)*sin(Q2 + Q3))*uy - sin(Q4)*cos(Q3 - Q2)*uz;

Q6 =atan2(sq6, cq6); 

Q1 = rad2deg(Q1)
Q2 = rad2deg(Q2)
Q3 = rad2deg(Q3)
Q4 = rad2deg(Q4)
Q5 = rad2deg(Q5)
Q6 = rad2deg(Q6)



