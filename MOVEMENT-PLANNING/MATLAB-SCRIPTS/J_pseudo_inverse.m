function [ J_pseudo, J ] = J_pseudo_inverse( now, resolution )
%Receives the jacobian function and outputs ints inverse in the given
%values of q in degrees.

J = zeros(6);
    for i = 1:6
        now_delta = update_now( now, i, resolution );
        J(1,i) = (now_delta.x - now.x)/resolution;
        J(2,i) = (now_delta.y - now.y)/resolution;
        J(3,i) = (now_delta.z - now.z)/resolution;
        J(4,i) = (now_delta.psi - now.psi)/resolution;
        J(5,i) = (now_delta.theta - now.theta)/resolution;
        J(6,i) = (now_delta.phi - now.phi)/resolution;
    end
    J_pseudo = pinv(J);

end

