function [ now ] = update_now( now, pos, value )
%This function receives the points of the actual moment and iterates it to
%the next moment

now.q(pos) = now.q(pos) +  value;
[pos, rot] = robotic_position(now.q);
now.x = pos(1);
now.y = pos(2);
now.z = pos(3);
now.psi = rot(1);
now.theta = rot(2);
now.phi = rot(3);

end

