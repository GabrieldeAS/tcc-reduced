% This code contains the tranformation matrices in the symbolic model and
% saves it into a .mat file for future use, this spares time of processing
clear all; %#ok<CLALL>
clc;


syms x y z theta psi phi;

%model matrix / euler rotation 'ZYZ'
M = [ 	cos(phi)*cos(psi)-sin(phi)*cos(theta)*sin(psi)  -cos(phi)*sin(psi)-sin(phi)*cos(theta)*cos(psi)     sin(phi)*sin(theta)     x
        sin(phi)*cos(psi)+cos(phi)*cos(theta)*sin(psi)  -sin(phi)*sin(psi)+cos(phi)*cos(theta)*cos(psi)     -cos(phi)*sin(theta)    y
        -sin(theta)*sin(psi)                            sin(theta)*cos(psi)                                 cos(theta)              z
        0                                               0                                                   0                       1];

syms q1 q2 q3 q4 q5 q6; % em radianos

T_01 = [    cos(q1) -sin(q1)    0       0
            sin(q1)  cos(q1)    0       0
            0          0        1       46.6
            0          0        0       1];   

T_12 = [ 	cos(q2)     0    sin(q2)    0
            0           1       0       0
            -sin(q2)    0    cos(q2)    105.8
            0           0       0       1];

T_23 = [ 	cos(q3)     0    sin(q3)    0
        	0           1       0       0
        	-sin(q3)    0    cos(q3)    129.8
        	0           0       0       1];

T_34 = [ 	cos(q4)     -sin(q4)    0   	0
        	sin(q4)     cos(q4)     0       0
        	0           0           1       0
        	0           0           0       1];
    
T_45 = [ 	cos(q5)     0    sin(q5)    0
        	0           1       0       0
        	-sin(q5)    0    cos(q5)    0
        	0           0       0       1];
     
T_56 = [ 	cos(q6) -sin(q6)    0       0
        	sin(q6)  cos(q6)    0       0
        	0           0       1       101.05
        	0           0       0       1];
    
T_67 = [ 	1           0       0       0
        	0           1       0       0
        	0           0       1       0
        	0           0       0       1];    
T_07 = simplify(T_01*T_12*T_23*T_34*T_45*T_56*T_67);

X = T_07(1,4);
Y = T_07(2,4);
Z = T_07(3,4);
Psi = atan2(T_07(3,2),-T_07(3,1));
Phi = atan2(T_07(1,3),-T_07(2,3));
Theta = atan2(T_07(3,2)/cos(Psi),T_07(3,3));

temp = simplify([   diff(X,q1) diff(X,q2) diff(X,q3) diff(X,q4) diff(X,q5) diff(X,q6)
                    diff(Y,q1) diff(Y,q2) diff(Y,q3) diff(Y,q4) diff(Y,q5) diff(Y,q6)
                    diff(Z,q1) diff(Z,q2) diff(Z,q3) diff(Z,q4) diff(Z,q5) diff(Z,q6)
                    diff(Psi,q1) diff(Psi,q2) diff(Psi,q3) diff(Psi,q4) diff(Psi,q5) diff(Psi,q6)
                    diff(Theta,q1) diff(Theta,q2) diff(Theta,q3) diff(Theta,q4) diff(Theta,q5) diff(Theta,q6)
                    diff(Phi,q1) diff(Phi,q2) diff(Phi,q3) diff(Phi,q4) diff(Phi,q5) diff(Phi,q6)]);

                
J(q1,q2,q3,q4,q5,q6) = temp';

%inviável, por falta de RAM
% J_pseudo(q1,q2,q3,q4,q5,q6) = pinv(temp);

                
                        
save('robotic_model_symbolic');