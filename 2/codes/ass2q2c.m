clc; clear;

I = imread("barbara256.png");
J = double(I(1:256,1:256));

global alpha B phi;

phi = randn(32,64);

B = phi.'*phi;

alpha = eigs(B,1);

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
%
function x = ista(y)
global B alpha phi;

temp1 = reshape(phi.'*y,[8 8]);
theta = randi(256,[4 4 4])-1;
i = 0;
while true
    i = i+1;
    [t1,t2,t3,t4]=dwt2(temp1-reshape(B*reshape(idwt2(theta(:,:,1),theta(:,:,2),theta(:,:,3),theta(:,:,4),'db1'),[64 1]),[8 8]),'db1');
    theta = wthresh(theta+cat(3,t1,t2,t3,t4)/alpha,'s',1/(2*alpha));
    if i > 15
        break
    end
end
x = idwt2(theta(:,:,1),theta(:,:,2),theta(:,:,3),theta(:,:,4),'db1');
end
%

%}


