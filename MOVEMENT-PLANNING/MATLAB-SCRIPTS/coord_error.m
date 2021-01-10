function [ error ] = coord_error( now , next )
%This funtion receives two positions and calculates the error between all
%of its variables and outputs an error vector.
error(1,1) = next.x - now.x;
error(2,1) = next.y - now.y;
error(3,1) = next.z - now.z;
error(4,1) = next.theta - now.theta;
error(5,1) = next.phi - now.phi;
error(6,1) = next.psi - now.psi;

end
