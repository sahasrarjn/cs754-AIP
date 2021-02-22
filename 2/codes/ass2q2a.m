clc; clear;

I = imread("barbara256.png");
J = double(I);
figure;
imshow(uint8(J));

J = J + randn(256,256)*2;
figure;
imshow(uint8(J));

global A alpha;

A = kron(dctmtx(8),dctmtx(8));
alpha = 1;

[x, y] = size(J);

R = zeros(x,y);
D = zeros(x,y);
%
for i = 1:x-7
    for j = 1:y-7
        D(i:i+7,j:j+7) = D(i:i+7,j:j+7)+1;
        R(i:i+7,j:j+7) = R(i:i+7,j:j+7)+ista(reshape(J(i:i+7,j:j+7),64,1));
    end
end


R = R./D;

figure();
imshow(uint8(R));


function x = ista(y)
    global A alpha
    theta = A.'*y;
    theta = soft(theta,1/(2*alpha));
    x = reshape(A*theta,8,8);
end


function x = soft(y,alpha)
    x = zeros(size(y));
    x( y >= alpha ) = y( y >= alpha )-alpha;
    x( y <= -alpha ) = y( y <= -alpha )+alpha;
end
