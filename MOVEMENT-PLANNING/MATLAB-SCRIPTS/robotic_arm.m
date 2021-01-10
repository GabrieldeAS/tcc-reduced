function robotic_arm( q )
%Draws the robotic arm described bellow, given the position of each servo actuator
%The input variables are given in degrees 

%[posicao_final, euler_ZYZ ] = //comentário de modificação

%clc
%close all
%conversão de unidades degree->rad
% q1 = deg2rad(q1);
% q2 = deg2rad(q2);
% q3 = deg2rad(q3);
% q4 = deg2rad(q4);
% q5 = deg2rad(q5);
% q6 = deg2rad(q6);
q = deg2rad(q);


%% Modelo Geométrico direto
    
    %Matrizes de Rotação
    
%obs: As dimensões estão em milímetros[mm];    
[T_01, T_12, T_23, T_34, T_45, T_56, T_67, T_02, T_03,T_04, T_05, T_06, T_07]  = robotic_arm_model(q);


%% Plot do braço

%Parâmetros da figura
figure1 = figure('Name','Robotic Arm','Color',[1 1 1]);
axes1 = axes('Parent',figure1);
axis equal
hold(axes1,'on');
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
title('Braçop Robótico');
box(axes1,'on');
grid on
view(-56 ,14)
%set(axes1,'FontSize',20,'XGrid','on','YGrid','on','ZGrid','on');
%saveas(figure1,Robot,'jpg')


                    %sphere na junta inicial
raio_sphere = 5;
resolucao_sphere = 10;

%coordenadas X, Y, Z da sphere
[x2, y2, z2] = sphere(resolucao_sphere);

%redimensionando a esfera
x2 = x2*raio_sphere;  
y2 = y2*raio_sphere;
z2 = z2*raio_sphere;

surf(x2, y2, z2,'FaceColor','k');

%                            juntas restantes


%Primeira junta
M  = T_01(1:3,1:3);
p0 = [0;0;0];
p1 = M*T_01(1:3,4) + p0;
color = 1;
plot_junction(p0, p1, M,color);

%Segunda junta
M  = T_02(1:3,1:3);
p0 = p1;
p1 = M*T_12(1:3,4) + p1;
color = 4;
plot_junction(p0, p1,M,color);

%Terceira junta
M  = T_03(1:3,1:3);
p0 = p1;
p1 = M*T_23(1:3,4) + p1;
color = 5;
plot_junction(p0, p1,M,color);

%Quarta junta
M  = T_06(1:3,1:3);
p0 = p1;
p1 = M*T_56(1:3,4) + p1;
color = 6;
plot_junction(p0, p1,M,color);


posicao_final  = p1;
str = [ 'X = ', num2str(posicao_final(1)), ...
        '  Y = ', num2str(posicao_final(2)),...
        '  Z = ', num2str(posicao_final(3))];
disp(str);

euler_ZYZ = matrix2euler(M);
str = [ 'rotZ = ', num2str(rad2deg(euler_ZYZ(1))), ...
        '  rotY = ', num2str(rad2deg(euler_ZYZ(2))),...
        '  rotZ = ', num2str(rad2deg(euler_ZYZ(3))),];
disp(str);
end

