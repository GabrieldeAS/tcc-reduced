%% Matrizes de movimento do Braço


%% Setup
clc;
tic
clear;

%% Modelo Geométrico direto
    
    %Matrizes de Rotação

%obs: As dimensões estão em milímetros[mm];

%load('robotic_model_symbolic');
%são carregados todas as matrizes necessárias para a execução do programa
%em especial, o jacobinao do sistema


%% Modelo geométrico inverso

%set das posição inicial e final do braço
now.q = [0, 0, 0, 0, 0, 0];
[pos, rot] = robotic_position(now.q1,now.q2,now.q3,now.q4,now.q5,now.q6);
now.x = pos(1);
now.y = pos(2);
now.z = pos(3);
now.phi = rot(1);
now.theta = rot(2);
now.psi = rot(3);


dream.q = [90,90,90,90,90,90];
[pos, rot] = robotic_position(dream.q1,dream.q2,dream.q3,dream.q4,dream.q5,dream.q60);
dream.x = pos(1);
dream.y = pos(2);
dream.z = pos(3);
dream.phi = rot(1);
dream.theta = rot(2);
dream.psi = rot(3);


%% Iterador
%loop de tentativa e erro que busca reduzir o erro entre o ponto desejado e
%o em que se encontra o braço

%parâmetros das iterações
resolution = 0.1;                   %resolução do movimento das juntas durante as iterações(0.1°)
i = 0;                              %número de iterações
i_max = 20000;                      %número de iterações máxima
min_error = 1;                      %erro desejado
error = coord_error(now,dream);     %cálculo do vetor de erro

while norm(error) > min_error
    
    for q = 1:6
        now = update_now(now, q, resolution);
        new_error = coord_error(now,dream);
        
        if
        
        while new_error
        end
    end
    
    now = update_now(now, [resolution, 0 0 0 0 0]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
        now = update_now(now, [-2*resolution, 0 0 0 0 0]);
        error = coord_error(now,dream);
    else
        error = new_error;
    end
    
    now = update_now(now, [0, resolution, 0 0 0 0]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
        now = update_now(now, [0,-2*resolution, 0 0 0 0]);
        error = coord_error(now,dream);
    else
        error = new_error;        
    end
    
    now = update_now(now, [0,0,resolution, 0 0 0]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
        now = update_now(now, [0,0,-2*resolution, 0 0 0]);
        error = coord_error(now,dream);
    else
        error = new_error;
    end
    
    now = update_now(now, [0,0,0,resolution, 0 0]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
        now = update_now(now, [0,0,0,-2*resolution, 0 0 0 0 0]);
        error = coord_error(now,dream);
    else
        error = new_error;
    end
    
    now = update_now(now, [0,0,0,0,resolution, 0]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
       now = update_now(now, [0,0,0,0,-2*resolution, 0]);
        error = coord_error(now,dream);
    else
        error = new_error;
    end
    
    now = update_now(now, [0,0,0,0,0,resolution]);
    new_error = coord_error(now,dream);
    if norm(new_error) > norm(error)
        now = update_now(now, [0,0,0,0,0,-2*resolution]);
        error = coord_error(now,dream);
    else
        error = new_error;
    end
    
  
    i = i+1;
    if i >i_max
        disp('Sem convergência');
        break;
    end
    clc
    i
    norm(error)
end

now
s = toc

% while norm(error) > min_error
%     
%     J_pseudo = J_pseudo_inverse( J, now.q1,now.q2,now.q3,now.q4,now.q5,now.q6);
%     
%     delta_q = resolution*J_pseudo*error;
%     
%     now = update_now(now,delta_q);
%     
%     error = coord_error(now,dream);
%     
%     clc
%     i = i+1;
%     if i >i_max
%         disp('Sem convergência');
%         break;
%     end
%   
% end