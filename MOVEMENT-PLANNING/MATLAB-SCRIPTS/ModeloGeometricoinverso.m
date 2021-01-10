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


dream.q = [5,3,2,22,55,77];
[pos, rot] = robotic_position(dream.q);
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
base_rotation = 50;                             %rotação base incial 10°
resolution = zeros(1,6)+base_rotation;          %resolução do movimento de cada junta juntas durante as iterações
revolution_iterator = 0.95;                      %resolução com que é ajustada a resolução do movimento das juntas
i = 0;                                          %número de iterações
i_max = 2000000;                                %número de iterações máxima
min_error = 1;                                  %erro desejado
error = coord_error(now,dream);                 %cálculo do vetor de erro
error_comparator = [norm(error) norm(error)];
trigger = 0;                                    %sinaliza que a resolução atual não movimenta a junta de forma a diminuir o erro
                                                %só é útil nos casos em que arotação em nenhum sentido colabora na redução do erro                                      

while norm(error) > min_error
    
    %loop que varre
    for q = 1:6
        
        %faz o movimento mínimo na junta
        now = update_now(now, q, resolution(q));
        new_error = coord_error(now,dream);
        
        %testa se o movimento aumentou o erro, e move para o outro lado, se
        %preciso
        if norm(new_error) > norm(error)
            temp = norm(new_error);
            resolution(q) = -1*resolution(q);
            now = update_now(now, q, 2*resolution(q));
            new_error = coord_error(now,dream);
            
            %se pro outro lado piorou mais ainda, volta o resolution
            if norm(new_error) > temp
                resolution(q) = -1*resolution(q);
                now = update_now(now, q, resolution(q)); %volta pra posição inicial
                trigger = 1;
            end
        end
        
        %Enquanto o erro diminuir, ajuste
        while norm(new_error) < norm(error)
            error = new_error;
            now = update_now(now, q, resolution(q));
            new_error = coord_error(now,dream);
        end
        
        %corrige ultimo erro
        if trigger ~= 1
            now = update_now(now, q, -1*resolution(q));
            error = coord_error(now,dream);
        else
            trigger = 0;
        end
        
%         if norm(new_error) > norm(error)
%             now = update_now(now, q, -1*resolution(q)); %concerta o movimento, pois nenhum dos dois deu certo
%             resolution(q) = resolution(q)*revolution_iterator;
%         else
%             error = new_error;
%         end

        
    end
    
    
           
        
     %muda a resolução, pois melhor n fica com essa que já existe
    error_comparator(1) = norm(error);
    if error_comparator(1) == error_comparator(2) 
            resolution = resolution*revolution_iterator;
    else
       error_comparator(2) = error_comparator(1); 
    
    end
    
%       %plot iterações
%     if rem(i,5) == 0
%         robotic_arm(now.q);
%     end
%     clc

%        %informações de debug
        i = i+1;
        
    %emergency jump - usado para se livrar de minimos locais
%     if i == 200%rem(i,200) == 0
%         q_emergency = rand(1,6)*180 *0.20 ;
%         for j =1:6
%             now = update_now(now, j, q_emergency(j));
%         end
%         error = coord_error(now,dream);                            
%         resolution = zeros(1,6)+base_rotation*0.3; 
%     end
       
    i 
    norm(error)
    s = toc
end

now
dream
s = toc
i

    % old test method
%     now = update_now(now, [resolution, 0 0 0 0 0]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%         now = update_now(now, [-2*resolution, 0 0 0 0 0]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;
%     end
%     
%     now = update_now(now, [0, resolution, 0 0 0 0]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%         now = update_now(now, [0,-2*resolution, 0 0 0 0]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;        
%     end
%     
%     now = update_now(now, [0,0,resolution, 0 0 0]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%         now = update_now(now, [0,0,-2*resolution, 0 0 0]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;
%     end
%     
%     now = update_now(now, [0,0,0,resolution, 0 0]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%         now = update_now(now, [0,0,0,-2*resolution, 0 0 0 0 0]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;
%     end
%     
%     now = update_now(now, [0,0,0,0,resolution, 0]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%        now = update_now(now, [0,0,0,0,-2*resolution, 0]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;
%     end
%     
%     now = update_now(now, [0,0,0,0,0,resolution]);
%     new_error = coord_error(now,dream);
%     if norm(new_error) > norm(error)
%         now = update_now(now, [0,0,0,0,0,-2*resolution]);
%         error = coord_error(now,dream);
%     else
%         error = new_error;
%     end
%     
%   
%     i = i+1;
%     if i >i_max
%         disp('Sem convergência');
%         break;
%     end
%     clc
%     i
%     norm(error)
% end



            % Jacobian method
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