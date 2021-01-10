%% Matrizes de movimento do Braço


%% Setup
clc;
tic
clear;


%% Modelo geométrico inverso
%set das posição inicial e final do braço
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
%o em que se encontra o braço

%parâmetros das iterações
resolution_base = 50;                           %rotação base incial 10°
resolution = resolution_base;                   %resolução do movimento de cada junta juntas durante as iterações
resolution_steps = [1  1/3  1/9];               %a resolução será diminuida segundo esses valores antes que o valor base seja alterado  
resolution_iterator = 0.8;                      %resolução com que é ajustada a resolução do movimento das juntas
i = 0;                                          %número de iterações
%i_max = 2000000;                               %número de iterações máxima
min_error = 1;                                  %erro desejado
error = coord_error(now,dream);                 %cálculo do vetor de erro
error_comparator = [norm(error) norm(error)];
melhorei = 0;                                   %mede se o erro aumentou ou diminuiu após uma resolução
while norm(error) > min_error
    
    %loop que percorre todas as juntas
    for q = 1:6
        
        for resolution = resolution_steps*resolution_base
            
            %faz o movimento mínimo na junta
            now_pos = update_now(now, q, resolution);
            error_pos = coord_error(now_pos,dream);
        
            %faz o movimento mínimo pro outro lado
            now_neg = update_now(now, q, -resolution);
            error_neg = coord_error(now_neg,dream);
            
            %vê qual sentido é melhor
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
            
            %correção do overshoot do ajuste do error, pois o while só sai
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
    
    %salva a diferença entre o erro em iterações anteriores e a atual
    %Com essa diferença é possível avaliar se é cabível mudar a resolução
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
    
%       %plot iterações
%     if rem(i,5) == 0
%        robotic_arm(now.q);
%     end
%     clc

%       %informações de debug
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