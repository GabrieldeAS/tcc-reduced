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
                                        % usando as matrizes de transformação
% atribuição das posições iniciais
original.q = now.q;
original.x = pos(1);
original.y = pos(2);
original.z = pos(3);
original.phi = rot(1);
original.theta = rot(2);
original.psi = rot(3);
%
now.x = pos(1);
now.y = pos(2);
now.z = pos(3);
now.phi = rot(1);
now.theta = rot(2);
now.psi = rot(3);

%set da posicao final
%dream.q = [5,3,2,22,55,77];
%dream.q = [45,60,0,90,0,0]; % usar juntas ou usar diretamente os parâmetros
%dream.q = [0,45,90,45,45,90];
dream.q = [60 ,  45 ,  90 , -15 ,  45 ,  75];
[pos, rot] = robotic_position(dream.q); % inversa?
dream.x = pos(1);
dream.y = pos(2);
dream.z = pos(3);
dream.phi = rot(1);
dream.theta = rot(2);
dream.psi = rot(3);

% restrição de espaço de estados (usar o .q para testar se existe primeiro)
%dream.x = 205;
%dream.y = 205;
%dream.z = 215;
%dream.phi = -135;
%dream.theta = -60;
%dream.psi = -90;


%% Geração de trajetória

%traj.dif = dream.q - original.q;
traj.a = dream.x-original.x;
traj.b = dream.y-original.y;
traj.c = dream.z-original.z;
traj.alpha = dream.phi-original.phi;
traj.beta = dream.theta-original.theta;
traj.gama = dream.psi-original.psi;

% definição de granularida
granularity = 15; % fixo em N passos
step = 1;

%% Parâmetros de otimização

%par�metros das itera��es
resolution = 1;                                 %delta rota��o base incial
%resolution = resolution_base;                  %resolu��o do movimento de cada junta juntas durante as itera��es
%resolution_iterator = 0.1;                      %resolu��o com que � ajustada a resolu��o do movimento das juntas
i = 0;                                          %n�mero de iteracoes
k = 0;
%i_max = 2000000;                               %n�mero de iteracoes maxima
min_error = 0.001;                              %erro desejado
%% Iterador duplo
%loop heurístico que busca reduzir o erro entre o ponto desejado e o em que se encontra o bra�o
while step <= granularity
    %disp("Hi");
    % atualizando próximo step
    %next.q = original.q + (step/granularity)*traj.dif;
    next.x = original.x + (step/granularity)*traj.a;
    next.y = original.y + (step/granularity)*traj.b;
    next.z = original.z + (step/granularity)*traj.c;
    next.phi = original.phi + (step/granularity)*traj.alpha;
    next.theta = original.theta + (step/granularity)*traj.beta;
    next.psi = original.psi + (step/granularity)*traj.gama;
    error = coord_error(now,next);      %c�lculo do vetor de erro
    while norm(error) > min_error
        % alguma forma de incluir condicionais
        [Ji, J] = J_pseudo_inverse( now, resolution );   %calcula a derivada multidimensional da fun��o
        delta_q = incrementAngle(now, next, Ji); % calcula o variacao de q para se chegar onde se quer (não usar isso diretamente) 
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
        error = coord_error(now,next);     %calcula o novo erro

        %       %plot iteracoes
         %if rem(i,5) == 0
             %figure (i+1)
             %name = "fig" + num2str(i+1);
             %robotic_arm_print(now.q,name); % danum2str
         %end
         %clc

        %       %informacoes de debug e iterador
        i = i+1;
        %clc
        %i 
        %norm(error)
        %s = toc
    end
    solution.q(step,1:6) = now.q;
    solution.terminal(step,1) = now.x;
    solution.terminal(step,2) = now.y;
    solution.terminal(step,3) = now.z;
    solution.terminal(step,4) = now.phi;
    solution.terminal(step,5) = now.theta;
    solution.terminal(step,6) = now.psi;
    % print de passos
    %figure (step)
    %name = "step" + num2str(step);
    %robotic_arm_print(now.q,name);
    %robotic_arm_print2(original,dream,now.q,name);
    %robotic_arm_animation(original,dream,now.q,name); deixa pro futuro kk
    % next
    step = step + 1;
end
%% Preparação dos dados para um formato útil (que pode ser consumido no micro)
% rem(,360)

%% disp de dados
%disp(now)
%disp(dream)
disp(toc)
disp(i)
disp(rem(solution.q,360))
%disp(norm(error))