%% Matrizes de movimento do Bra�o


%% Setup
clc;
tic
clear;


%% Modelo geom�trico inverso
%set das posi��o inicial e final do bra�o
tic
now.q = [0, 0, 0, 0, 0, 0];
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

dream.x = -40;
dream.y = 180;
dream.z = 140;
dream.psi = 45; %
dream.theta = 0;
dream.phi = 0;


%% Iterador
%loop de tentativa e erro que busca reduzir o erro entre o ponto desejado e
%o em que se encontra o bra�o

%par�metros das itera��es
resolution = 0.001;                             %delta rota��o base incial 
%resolution = resolution_base;                  %resolu��o do movimento de cada junta juntas durante as itera��es
resolution_iterator = 0.1;                      %resolu��o com que � ajustada a resolu��o do movimento das juntas
i = 0;                                          %n�mero de itera��es
%i_max = 2000000;                               %n�mero de itera��es m�xima
min_error = 1;                                  %erro desejado
error = coord_error(now,dream);                 %c�lculo do vetor de erro
%error_comparator = [norm(error) norm(error)];
%trigger = 0;                                    %sinaliza que a resolu��o atual n�o movimenta a junta de forma a diminuir o erro
                                                %s� � �til nos casos em que arota��o em nenhum sentido colabora na redu��o do erro                                      
%melhorei = 0;                                   %mede se o erro aumentou ou diminuiu ap�s uma resolu��o
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
%     
%     error_comparator(1) = norm(error);
%     if error_comparator(1) >= error_comparator(2) 
%         if resolution_base >0.001
%             resolution_base = resolution_base*resolution_iterator;
%         end
%     else
%        error_comparator(2) = error_comparator(1);
%     end
    
%       %plot itera��es
%     if rem(i,5) == 0
%         robotic_arm_print(now.q,[danum2str(i)]);
%     end
%     clc

%       %informa��es de debug
        i = i+1;
    clc
    i 
    norm(error)
    s = toc
end

now
dream
s = toc
i
norm(error)