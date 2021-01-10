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
now.phi = rot(1);
now.theta = rot(2);
now.psi = rot(3);


%dream.q = [5,3,2,22,55,77];
%dream.q = [40,40,40,40,40,40];
% [pos, rot] = robotic_position(dream.q);
% dream.x = pos(1);
% dream.y = pos(2);
% dream.z = pos(3);
% dream.phi = rot(1);
% dream.theta = rot(2);
% dream.psi = rot(3);

dream.x = -34.56;
dream.y = 299.56;
dream.z = 121.41;
dream.phi = -70;
dream.theta = -90;
dream.psi = -60;


%% Iterador
%loop de tentativa e erro que busca reduzir o erro entre o ponto desejado e
%o em que se encontra o bra�o

%par�metros das itera��es
resolution_base = 50;                           %rota��o base incial 10�
resolution = resolution_base;                   %resolu��o do movimento de cada junta juntas durante as itera��es
resolution_steps = [1  1/3  1/9];               %a resolu��o ser� diminuida segundo esses valores antes que o valor base seja alterado  
resolution_iterator = 0.8;                      %resolu��o com que � ajustada a resolu��o do movimento das juntas
i = 0;                                          %n�mero de itera��es
%i_max = 2000000;                               %n�mero de itera��es m�xima
min_error = 1;                                  %erro desejado
error = coord_error(now,dream);                 %c�lculo do vetor de erro
error_comparator = [norm(error) norm(error)];
melhorei = 0;                                   %mede se o erro aumentou ou diminuiu ap�s uma resolu��o
while norm(error) > min_error
    
    %loop que percorre todas as juntas
    for q = 1:6
        
        for resolution = resolution_steps*resolution_base
            
            %faz o movimento m�nimo na junta
            now_pos = update_now(now, q, resolution);
            error_pos = coord_error(now_pos,dream);
        
            %faz o movimento m�nimo pro outro lado
            now_neg = update_now(now, q, -resolution);
            error_neg = coord_error(now_neg,dream);
            
            %v� qual sentido � melhor
            if norm(error_pos) <= norm(error_neg)  
                sentido = 1;
                new_error = error_pos;
            else
                sentido = -1;
                new_error = error_neg;
            end
        
            
            %confere se realmente ouve melhoria no processo
            if norm(new_error) < norm(error)
                melhorei = 1;
                if sentido == 1
                    now = now_pos;
                    %Enquanto o erro diminuir, ajuste
                    while norm(new_error) < norm(error)
                        error = new_error;
                        now = update_now(now, q, resolution);
                        new_error = coord_error(now,dream);
                    end
                else
                    now = now_neg;
                    %Enquanto o erro diminuir, ajuste
                    while norm(new_error) < norm(error)
                        error = new_error;
                        now = update_now(now, q, -resolution);
                        new_error = coord_error(now,dream);
                    end
                end
            end
            
            %corre��o do overshoot do ajuste do error, pois o while s� sai
            %do loop rodou demias
            if melhorei == 1
                if sentido == 1
                    now = update_now(now, q, -resolution);
                else
                    now = update_now(now, q,+resolution);
                end
                melhorei = 0;
            end
            
        end
    end
    
    %salva a diferen�a entre o erro em itera��es anteriores e a atual
    %Com essa diferen�a � poss�vel avaliar se � cab�vel mudar a resolu��o
    %do passo
    error_comparator(1) = norm(error);
    if error_comparator(1) == error_comparator(2)
        
    %if error_comparator(1)/error_comparator(2) >= 0.6
        if resolution_base >0.001
            resolution_base = resolution_base*resolution_iterator;
        end
    else
       error_comparator(2) = error_comparator(1);
    end
    
%       %plot itera��es
%     if rem(i,5) == 0
%        robotic_arm(now.q);
%     end
%     clc

%       %informa��es de debug
        i = i+1;
    clc
    i 
    norm(error)
    s = toc
    pause(0.01)
    
end

now
dream
s = toc
i