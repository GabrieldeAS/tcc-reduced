%% Matrizes de movimento do Bra�o


%% Setup
clc;
tic
clear;


%% Modelo geom�trico inverso
%set das posi��o inicial e final do bra�o
tic
now.q = [24,19,-30,66,258,33]; % valor bagunçado
[pos, rot] = robotic_position(now.q);
now.x = pos(1);
now.y = pos(2);
now.z = pos(3);
now.psi = rot(1);
now.theta = rot(2);
now.phi = rot(3);


%dream.q = [5,3,2,22,55,77];
%dream.q = [0,30,30,0,60,0];
%[pos, rot] = robotic_position(dream.q);
%dream.x = pos(1);
%dream.y = pos(2);
%dream.z = pos(3);
%dream.psi = rot(1);
%dream.theta = rot(2);
%dream.phi = rot(3);

dream.x = -40; % -120 -40 40 120  
dream.y = 80;  
dream.z = 75; %  105 75 45 15
dream.psi = -90;
dream.theta = -180;
dream.phi = 0;
% PROBLEMÁTICO (ENTRA EM ZONA PROIBITIVA ou tem auto-conflito algumas vezes) 


%% Iterador
%loop de tentativa e erro que busca reduzir o erro entre o ponto desejado e
%o em que se encontra o bra�o

%par�metros das itera��es
resolution = 1;                            %delta rota��o base incial 
i = 0;                                          %n�mero de itera��es
%i_max = 2000000;                               %n�mero de itera��es m�xima
min_error = 0.01;                                  %erro desejado
error = coord_error(now,dream);                 %c�lculo do vetor de erro

while norm(error) > min_error
    
    [Ji, J] = J_pseudo_inverse( now, resolution );   %calcula a derivada multidimensional da fun��o
    delta_q = incrementAngle(now, dream, Ji);   %calcula o varia��o de q para se chegar onde se quer
    
    now.q = now.q + delta_q;
    [pos, rot] = robotic_position(now.q);
    now.x = pos(1);
    now.y = pos(2);
    now.z = pos(3);
    now.psi = rot(1);
    now.theta = rot(2);
    now.phi = rot(3);
    
    error = coord_error(now,dream);     %calcula o novo erro
        i = i+1;
    clc
    i 
    display(norm(error))
    s = toc
end

display(rem(now.q,360))
%s = toc
%i
%norm(error)