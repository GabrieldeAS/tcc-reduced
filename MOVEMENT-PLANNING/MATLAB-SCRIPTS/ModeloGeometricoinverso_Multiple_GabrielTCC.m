%% Matrizes de Movimento do Braco

% log
%Correção na inversão de Psi e Phi, vetores do TCC
%

%% Setup
clc;
clear all;
close all;

%% Modelo geom�trico inverso
% pode-se usar de angulos das juntas e conversão ou diretamente o terminal
%set da posicao inicial
tic
%now.q = [0, 0, 0, 0, 0, 0];             % ângulos das juntas
now.q= [-60, -20, 38.6, -86.1, -17.4, 29.52];
[pos, rot] = robotic_position(now.q);   % converte ângulos das juntas em posição do elemento terminal
                                        % usando as matrizes de transformação
% atribuição das posições iniciais
original.q = now.q;
original.x = pos(1);
original.y = pos(2);
original.z = pos(3);
original.psi = rot(1);
original.theta = rot(2);
original.phi = rot(3);
%original.x = -40;
%original.y = 80;
%original.z = 105;
%original.psi = -90;
%original.theta = -180;
%original.phi = 0;
%original.q = [116.5653, -14.8339, 78.6985, 0, -243.8650, 206.5652];

%
now.q = original.q;
now.x = original.x;
now.y = original.y;
now.z = original.z;
now.psi = original.psi;
now.theta = original.theta;
now.phi = original.phi;
%
current.x = now.x;
current.y = now.y;
current.z = now.z;
current.psi = now.psi;
current.theta = now.theta;
current.phi = now.phi;
%set da posicao final
%dream.q = [45,60,90,45,45,90];
%[pos, rot] = robotic_position(dream.q); % inversa?
%dream.x = pos(1);
%dream.y = pos(2);
%dream.z = pos(3);
%dream.phi = rot(1);
%dream.theta = rot(2);
%dream.psi = rot(3);
%{
  refs: [-45 , -60 , -90 , -45 , -45 , -90]^T; 
        [ 90 , -30 ,  0  , 180 , -90 ,  35]^T; 
        [ 60 ,  45 ,  90 , -15 ,  45 ,  75]^T;
%}
% restrição de espaço de estados (usar o .q para testar se existe primeiro)
dream.x =     [ -40];
dream.y =     [  80];
dream.z =     [ 105];
dream.psi =   [ -90];
dream.theta = [-180];
dream.phi =   [   0];


%% Geração de trajetória

%traj.dif = dream.q - original.q;
traj.a(1) = dream.x(1)-original.x;
traj.b(1) = dream.y(1)-original.y;
traj.c(1) = dream.z(1)-original.z;
traj.alpha(1) = dream.psi(1)-original.psi;
traj.beta(1) = dream.theta(1)-original.theta;
traj.gama(1) = dream.phi(1)-original.phi;

objIte = 2;
while objIte <= length(dream.x)
    traj.a(objIte) = dream.x(objIte) - dream.x(objIte-1);
    traj.b(objIte) = dream.y(objIte) - dream.y(objIte-1);
    traj.c(objIte) = dream.z(objIte) - dream.z(objIte-1);
    traj.alpha(objIte) = dream.psi(objIte)   - dream.psi(objIte-1);
    traj.beta(objIte)  = dream.theta(objIte) - dream.theta(objIte-1);
    traj.gama(objIte)  = dream.phi(objIte)   - dream.phi(objIte-1);
    %
    objIte = objIte + 1;
end
% definição de granularida
granularity = 20; % fixo em N passos 5//50//500
step = 1;
objIte = 1;
%% Parâmetros de otimização

%par�metros das iteracoes
resolution = 0.1;                                 %delta rotacao base incial

i = 0;                                          %numero de iteracoes
%i_max = 2000000;                               %numero de iteracoes maxima
min_error = 0.01;                              %erro desejado

%% Iterador triplo
%loop heurístico que busca reduzir o erro entre o ponto desejado e o em que se encontra o bra�o
tic
while objIte <= length(dream.x) % while objIte <= 2 %while objIte <= length(dream.x)
    while step <= granularity
        %disp("Hi");
        % atualizando próximo step
        %next.q = original.q + (step/granularity)*traj.dif;
        next.x = current.x + (step/granularity)*traj.a(objIte);
        next.y = current.y + (step/granularity)*traj.b(objIte);
        next.z = current.z + (step/granularity)*traj.c(objIte);
        next.psi   = current.psi + (step/granularity)*traj.alpha(objIte);
        next.theta = current.theta + (step/granularity)*traj.beta(objIte);
        next.phi   = current.phi + (step/granularity)*traj.gama(objIte);
        error = coord_error(now,next);      %c�lculo do vetor de erro
        % now != current (now é o atual verdadeiro e current é o ideal)
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
            now.psi = rot(1);
            now.theta = rot(2);
            now.phi = rot(3);
            % vetor de valores
            array.q(i+1,1:6) = now.q;
            array.terminal(i+1,1) = now.x;
            array.terminal(i+1,2) = now.y;
            array.terminal(i+1,3) = now.z;
            array.terminal(i+1,4) = now.psi;
            array.terminal(i+1,5) = now.theta;
            array.terminal(i+1,6) = now.phi;
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
            clc
            i 
            norm(error)
            %s = toc
        end
        solution.q(step,1:6) = now.q;
        solution.terminal(step,1) = now.x;
        solution.terminal(step,2) = now.y;
        solution.terminal(step,3) = now.z;
        solution.terminal(step,4) = now.psi;
        solution.terminal(step,5) = now.theta;
        solution.terminal(step,6) = now.phi;
        % print de passos
        %figure (step)
        %name = "step" + num2str(step);
        %robotic_arm_print(now.q,name);
        %robotic_arm_print2(original,dream,now.q,name);
        %robotic_arm_animation(original,dream,now.q,name); deixa pro futuro kk
        % next
        step = step + 1;
    end
    finalError(objIte) = norm(error);
    % disp of one objective solution
    disp(toc)
    disp(i)
    disp(rem(solution.q,360))
    % preparation for next loop
    current.x = dream.x(objIte);
    current.y = dream.y(objIte);
    current.z = dream.z(objIte);
    current.psi   = dream.psi(objIte);
    current.theta = dream.theta(objIte);
    current.phi   = dream.phi(objIte);
    %
    disp(current)
    disp(finalError(objIte))
    %
    step = 1;
    objIte = objIte + 1;
end
%% Preparação dos dados para um formato útil (que pode ser consumido no micro)
% rem(,360)

%% disp de dados
%disp(now)
%disp(dream)

%disp(norm(error))