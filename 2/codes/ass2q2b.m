clc; clear;

I = imread("barbara256.png");
J = double(I(1:256,1:256));

global A B alpha U;

phi = randn(32,64);
U = kron(dctmtx(8),dctmtx(8));
A = phi*U;
B = A.'*A;
alpha = eigs(B,1)+2;

[x, y] = size(J);

R = zeros(x,y);
D = zeros(x,y);
%
for i = 1:x-7
    for j = 1:y-7
        D(i:i+7,j:j+7) = D(i:i+7,j:j+7)+1;
        R(i:i+7,j:j+7) = R(i:i+7,j:j+7)+ista(phi*reshape(J(i:i+7,j:j+7),64,1));
    end
end

R = R./D;

figure();
imshow(uint8(R));

function x = ista(y)
    global A B alpha U
    temp1 = A.'*y;
    theta = randi(256,[64 1])-1;
    i = 0;
    while true
        thetanxt = wthresh(theta+(temp1-B*theta)/alpha,'s',20/alpha);
        if norm(thetanxt-theta) <= 0.1
            theta = thetanxt;
            break
        end
        theta = thetanxt;
    end
    x = reshape(U*theta,8,8);
end

%}
