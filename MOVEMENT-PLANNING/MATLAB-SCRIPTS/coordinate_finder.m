% Iteration finder

%% Setup

clc
clear
close all

dream.x = 116;
dream.y = 0;
dream.z = -50;
dream.phi = -0;
dream.theta = -180;
dream.psi = 90;

%find coordinate

[ now ] = geometric_inverse( dream );