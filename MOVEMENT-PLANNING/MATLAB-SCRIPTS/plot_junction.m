function [ ] = plot_junction( P0, P1, M, c)
%Função que recebe dois pontos com as coordenadas X Y Z e plota um cilindro
% e uma esfera na sua extrimadade, representando uma junção robótica
% P0 - primeiro ponto
% P1 - segundo ponto
% c  - cor da junta

hold on


%vetor de cores;
cores = [	'y'       %yellow
            'm'       %magenta
            'c'       %cyan
            'r'       %red
            'g'       %green
            'b'       %blue
            'w'       %white
            'k'];     %black
%% Parâmetros do cilindro e da esfera


raio_cylinder = 5;
raio_sphere = raio_cylinder;
resolucao_cilindro = 4;
resolucao_sphere = 10;

%ambas as funções retornam as coordenadas X, Y, Z dos elementos
[x1, y1, z1] = cylinder(raio_cylinder,resolucao_cilindro);
[x2, y2, z2] = sphere(resolucao_sphere);

%redimensionando a esfera edando offset
x2 = x2*raio_sphere + P1(1);  
y2 = y2*raio_sphere + P1(2);
z2 = z2*raio_sphere + P1(3);

%% Algebrismos e plots
%orientação e ajuste de tamanho dos elementos

%comprimento do cilindro
tamanho_cilindro = norm(P1-P0);
z1 = z1*tamanho_cilindro;

%offset do cilindro
x1 = x1 + P0(1);
y1 = y1 + P0(2);
z1 = z1 + P0(3);

%rotação do cilindro
h = surf(x1, y1, z1,'FaceColor',cores(c));
rotacao = matrix2ang(M);%vrrotvec([0 0 1 ],P1 - P0);
rotate(h, rotacao(1:3),rad2deg(rotacao(4)),P0);

%plot da sphere
surf(x2 , y2 , z2 ,'FaceColor',cores(7));
end
