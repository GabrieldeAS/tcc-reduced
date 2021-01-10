%% Matrizes de movimento do Braço


%% Setup
clc;

clear;

syms q1 q2 q3 q4 q5 q6; %rotação dos servos em radianos / 6 graus de liberdade 
L1 = 46.6;
L2 = 105.8;
L3 = 129.8;
L4 = 101.5;

DH = [  0       L2      0       0       0       0
        L1      0       L3      0       0       L4
        q1      q2-pi/2	q3      q4      q5+pi/2	q6
        -pi/2 	0       -pi/2   pi/2    -pi/2   0]; 

%as linhas na matriz DH representam
%1- a (distância entre os eixos Z, ao longo de x)
%2- d (distância entre os eixos X, ao longo de z)
%3- theta (ângulo entre os eixos X, em torno de z)
%4- alfa (ângulo entre os eixos Z, em torno de x)
    
%% Modelo Geométrico direto
%obs: As dimensões estão em milímetros[mm];

T_12 = simplify([   cos(DH(3,1))    -cos(DH(4,1))*sin(DH(3,1))  sin(DH(4,1))*sin(DH(3,1))   DH(1,1)*cos(DH(3,1))
                    sin(DH(3,1))    cos(DH(4,1))*cos(DH(3,1))   -sin(DH(4,1))*cos(DH(3,1))  DH(1,1)*sin(DH(3,1))
                    0               sin(DH(4,1))                cos(DH(4,1))                DH(2,1)
                    0               0                           0                           1]);
    
T_23 = simplify([   cos(DH(3,2))    -cos(DH(4,2))*sin(DH(3,2))  sin(DH(4,2))*sin(DH(3,2))   DH(1,2)*cos(DH(3,2))
                    sin(DH(3,2))    cos(DH(4,2))*cos(DH(3,2))   -sin(DH(4,2))*cos(DH(3,2))  DH(1,2)*sin(DH(3,2))
                    0               sin(DH(4,2))                cos(DH(4,2))                DH(2,2)
                    0               0                           0                           1]);
    
    
    
T_34 = simplify(    [cos(DH(3,3))    -cos(DH(4,3))*sin(DH(3,3))  sin(DH(4,3))*sin(DH(3,3))   DH(1,3)*cos(DH(3,3))
                    sin(DH(3,3))    cos(DH(4,3))*cos(DH(3,3))   -sin(DH(4,3))*cos(DH(3,3))  DH(1,3)*sin(DH(3,3))
                    0               sin(DH(4,3))                cos(DH(4,3))                DH(2,3)
                    0               0                           0                           1]);
    
T_45 = simplify([   cos(DH(3,4))    -cos(DH(4,4))*sin(DH(3,4))  sin(DH(4,4))*sin(DH(3,4))   DH(1,4)*cos(DH(3,4))
                    sin(DH(3,4))    cos(DH(4,4))*cos(DH(3,4))   -sin(DH(4,4))*cos(DH(3,4))  DH(1,4)*sin(DH(3,4))
                    0               sin(DH(4,4))                cos(DH(4,4))                DH(2,4)
                    0               0                           0                           1]);
    
T_56 = simplify([   cos(DH(3,5))    -cos(DH(4,5))*sin(DH(3,5))  sin(DH(4,5))*sin(DH(3,5))   DH(1,5)*cos(DH(3,5))
                    sin(DH(3,5))    cos(DH(4,5))*cos(DH(3,5))   -sin(DH(4,5))*cos(DH(3,5))  DH(1,5)*sin(DH(3,5))
                    0               sin(DH(4,5))                cos(DH(4,5))                DH(2,5)
                    0               0                           0                           1]);
    
T_67 = simplify([   cos(DH(3,6))    -cos(DH(4,6))*sin(DH(3,6))  sin(DH(4,6))*sin(DH(3,6))   DH(1,6)*cos(DH(3,6))
                    sin(DH(3,6))    cos(DH(4,6))*cos(DH(3,6))   -sin(DH(4,6))*cos(DH(3,6))  DH(1,6)*sin(DH(3,6))
                    0               sin(DH(4,6))                cos(DH(4,6))                DH(2,6)
                    0               0                           0                           1]);
    
T_17 = simplify(T_12*T_23*T_34*T_45*T_56*T_67);
T_27 = simplify(T_23*T_34*T_45*T_56*T_67);
T_37 = simplify(T_34*T_45*T_56*T_67);
T_47 = simplify(T_45*T_56*T_67);
T_57 = simplify(T_56*T_67);

T_26 = simplify(T_23*T_34*T_45*T_56);

T_13 = simplify(T_12*T_23);
T_14 = simplify(T_12*T_23*T_34);
T_15 = simplify(T_12*T_23*T_34*T_45);
T_16 = simplify(T_12*T_23*T_34*T_45*T_56);

%% Modelo geométrico inverso

syms x y z theta psi phi a b;

%model matrix
M = [ 	cos(phi)*cos(psi)-sin(phi)*cos(theta)*sin(psi)  -cos(phi)*sin(psi)-sin(phi)*cos(theta)*cos(psi)     sin(phi)*sin(theta)     x
        sin(phi)*cos(psi)+cos(phi)*cos(theta)*sin(psi)  -sin(phi)*sin(psi)+cos(phi)*cos(theta)*cos(psi)     -cos(phi)*sin(theta)    y
        -sin(theta)*sin(psi)                            sin(theta)*cos(psi)                                 cos(theta)              z
        0                                               0                                                   0                       1];


% Solução do MGI 

% q1
Q1(x,y) = atan2(y,x);

% q2 e q3

circ1 = a^2 + b^2 == L2;
circ2 = (y-a)^2 + (z-b)^2 == L3;

center = solve([circ1,circ2], [a,b]); %centro da circunferência
A(y,z) = center.a(1); 
B(y,z) = center.b(1);
Q2 = atan2(B,A);
ang = atan2(y-A,z-B);
Q3 = Q2-ang;

%q4
iT_45 = simplify(inv(T_45));
T_end = simplify(iT_45*M);
eq1 = T_end(1,4) == T_57(1,4);
eq2 = T_end(2,4) == T_57(1,4);
eq3 = T_end(3,4) == T_57(1,4);
%q_1 = solve([eq1,eq3],[q1,q2]);

% T_end(:,4)
% T_27(:,4)
