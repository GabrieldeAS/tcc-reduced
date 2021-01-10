%% Matrizes de movimento do Bra�o

%% Setup
clc;
clear;
tic

%% Modelo geom�trico inverso
% pode-se usar de angulos das juntas e conversão ou diretamente o terminal

%set da posi��o inicial
tic
now.q = [0, 0, 0, 0, 0, 0];             % ângulos das juntas 
[pos, rot] = robotic_position(now.q);   % converte ângulos das juntas em posição do elemento terminal
                                        % usando as matrizes de
                                        % transformação
% atribuição das posições iniciais
now.x = pos(1);
now.y = pos(2);
now.z = pos(3);
now.phi = rot(1);
now.theta = rot(2);
now.psi = rot(3);

%set da posi��o final
%dream.q = [5,3,2,22,55,77];
dream.q = [0,45,90,45,45,90];
[pos, rot] = robotic_position(dream.q);
dream.x = pos(1);
dream.y = pos(2);
dream.z = pos(3);
dream.phi = rot(1);
dream.theta = rot(2);
dream.psi = rot(3);

%% Parâmetros de otimização

%par�metros das itera��es
resolution = 0.001;                             %delta rota��o base incial 
%resolution = resolution_base;                  %resolu��o do movimento de cada junta juntas durante as itera��es
resolution_iterator = 0.1;                      %resolu��o com que � ajustada a resolu��o do movimento das juntas
i = 0;                                          %n�mero de itera��es
%i_max = 2000000;                               %n�mero de itera��es m�xima
min_error = 0.001;                              %erro desejado
error = coord_error(now,dream);                 %c�lculo do vetor de erro
%error_comparator = [norm(error) norm(error)];
%trigger = 0;                                    %sinaliza que a resolu��o atual n�o movimenta a junta de forma a diminuir o erro
                                                 %s� � �til nos casos em que arota��o em nenhum sentido colabora na redu��o do erro                                      
%melhorei = 0;                                   %mede se o erro aumentou ou diminuiu ap�s uma resolu��o

%% Iterador
%loop heurístico que busca reduzir o erro entre o ponto desejado e o em que se encontra o bra�o
while norm(error) > min_error
    % alguma forma de incluir condicionais
    [Ji, J] = J_pseudo_inverse( now, resolution );   %calcula a derivada multidimensional da fun��o
    delta_q = incrementAngle(now, dream, Ji);   %calcula o varia��o de q para se chegar onde se quer
    % atualização dos valores atuais
    now.q = now.q + delta_q;
    [pos, rot] = robotic_position(now.q);
    now.x = pos(1);
    now.y = pos(2);
    now.z = pos(3);
    now.phi = rot(1);
    now.theta = rot(2);
    now.psi = rot(3);
    % vetor de valores
    array.q(i+1,1:6) = now.q;
    array.terminal(i+1,1) = now.x;
    array.terminal(i+1,2) = now.y;
    array.terminal(i+1,3) = now.z;
    array.terminal(i+1,4) = now.phi;
    array.terminal(i+1,5) = now.theta;
    array.terminal(i+1,6) = now.psi;
    %
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
     %if rem(i,5) == 0
         %figure (i+1)
         %name = "fig" + num2str(i+1);
         %robotic_arm_print(now.q,name); % danum2str
     %end
     clc

%       %informa��es de debug e iterador
    i = i+1;
    %clc
    %i 
    %norm(error)
    %s = toc
end
%% Preparação dos dados para um formato útil (que pode ser consumido no micro)
% rem(,360)

%% disp de dados
disp(now)
disp(dream)
disp(toc)
disp(i)
disp(norm(error))