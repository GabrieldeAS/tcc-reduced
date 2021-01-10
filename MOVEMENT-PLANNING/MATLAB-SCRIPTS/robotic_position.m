function [ posicao_final, euler_rot_ZYZ ] = robotic_position( q )
%This funcion receives all the the rotations in degrees and outputs the
%final position of the arm in 6 dof(degrees of freedom)

%conversão de unidades degree->rad
q = deg2rad(q);

[T_01, T_12, T_23, T_34, T_45, T_56, T_67, T_02, T_03,T_04, T_05, T_06, T_07]  = robotic_arm_model(q); %#ok<ASGLU>

%Primeira junta
p0 = [0;0;0];
M  = T_01(1:3,1:3);
p1 = M*T_01(1:3,4) + p0;
%Segunda junta
M  = T_02(1:3,1:3);
p1 = M*T_12(1:3,4) + p1;
%Terceira junta
M  = T_03(1:3,1:3);
p1 = M*T_23(1:3,4) + p1;
%Quarta junta
M  = T_04(1:3,1:3);
p1 = M*T_34(1:3,4) + p1;
%Quinta junta
M  = T_05(1:3,1:3);
p1 = M*T_45(1:3,4) + p1;
%Sexta junta
M  = T_06(1:3,1:3);
p1 = M*T_56(1:3,4) + p1;

posicao_final = p1;
euler_rot_ZYZ = rad2deg(matrix2euler(M));
end

