function [T_01, T_12, T_23, T_34, T_45, T_56, T_67, T_02, T_03,T_04, T_05, T_06, T_07] = robotic_arm_model(q)
%This function is a compact form to utilize the direct kinematic of the
%modeled arm. It receives as inputs the value of rotation (rads) and
%returns the values of several matrices of transformation

T_01 = [    cos(q(1)) -sin(q(1))    0       0
            sin(q(1))  cos(q(1))    0       0
            0          0        1       46.6
            0          0        0       1];   

T_12 = [ 	cos(q(2))     0    sin(q(2))    0
            0           1       0       0
            -sin(q(2))    0    cos(q(2))    105.8
            0           0       0       1];

T_23 = [ 	cos(q(3))     0    sin(q(3))    0
        	0           1       0       0
        	-sin(q(3))    0    cos(q(3))    129.8
        	0           0       0       1];

T_34 = [ 	cos(q(4))     -sin(q(4))    0   	0
        	sin(q(4))     cos(q(4))     0       0
        	0           0           1       0
        	0           0           0       1];
    
T_45 = [ 	cos(q(5))     0    sin(q(5))    0
        	0           1       0       0
        	-sin(q(5))    0    cos(q(5))    0
        	0           0       0       1];
     
T_56 = [ 	cos(q(6)) -sin(q(6))    0       0
        	sin(q(6))  cos(q(6))    0       0
        	0           0       1       101.05
        	0           0       0       1];
    
T_67 = [ 	1           0       0       0
        	0           1       0       0
        	0           0       1       0
        	0           0       0       1];    
        
T_02 = T_01*T_12;
T_03 = T_01*T_12*T_23;
T_04 = T_01*T_12*T_23*T_34;
T_05 = T_01*T_12*T_23*T_34*T_45;
T_06 = T_01*T_12*T_23*T_34*T_45*T_56;
T_07 = T_01*T_12*T_23*T_34*T_45*T_56*T_67;

end

