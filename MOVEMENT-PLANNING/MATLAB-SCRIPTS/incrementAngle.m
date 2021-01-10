function [delta_q] = incrementAngle(now, next, Ji)
% This function calculates the needed increment to the robot joints
% acording to the pseudo Inverse Jacobian matrix.
% não pode usar 
delta_pos = zeros(1,6);
delta_pos(1) = next.x - now.x;
delta_pos(2) = next.y - now.y;
delta_pos(3) = next.z - now.z;
delta_pos(4) = next.psi - now.psi;
delta_pos(5) = next.theta - now.theta;
delta_pos(6) = next.phi - now.phi;

delta_q = Ji*delta_pos';
delta_q = rem(delta_q,360)';
end

