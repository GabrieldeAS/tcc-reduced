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
%o em que se encontra o bra�o

%par�metros das itera��es
base_rotation = 50;                             %rota��o base incial 10�
resolution = zeros(1,6)+base_rotation;          %resolu��o do movimento de cada junta juntas durante as itera��es
revolution_iterator = 0.95;                      %resolu��o com que � ajustada a resolu��o do movimento das juntas
i = 0;                                          %n�mero de itera��es
i_max = 2000000;                                %n�mero de itera��es m�xima
min_error = 1;                                  %erro desejado
error = coord_error(now,dream);                 %c�lculo do vetor de erro
error_comparator = [norm(error) norm(error)];
trigger = 0;                                    %sinaliza que a resolu��o atual n�o movimenta a junta de forma a diminuir o erro
                                                %s� � �til nos casos em que arota��o em nenhum sentido colabora na redu��o do erro                                      

while norm(error) > min_error
    
    %loop que varre
    for q = 1:6
        
        %faz o movimento m�nimo na junta
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
                now = update_now(now, q, resolution(q)); %volta pra posi��o inicial
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
    
    
           
        
     %muda a resolu��o, pois melhor n fica com essa que j� existe
    error_comparator(1) = norm(error);
    if error_comparator(1) == error_comparator(2) 
            resolution = resolution*revolution_iterator;
    else
       error_comparator(2) = error_comparator(1); 
    
    end
    
%       %plot itera��es
%     if rem(i,5) == 0
%         robotic_arm(now.q);
%     end
%     clc

%        %informa��es de debug
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
%         disp('Sem converg�ncia');
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
%         disp('Sem converg�ncia');
%         break;
%     end
%   
% end