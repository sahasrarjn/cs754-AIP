clc; clear;

I = imread("barbara256.png");
J = double(I(1:256,1:256));

global alpha A B;

phi = randn(32,64);

A = zeros(32,64);

for i = 1:32
    [t1, t2, t3, t4] = dwt2(reshape(phi(i,:),8,8),'db1');
    A(i,1:16) = reshape(t1,1,16);
    A(i,17:32) = reshape(t2,1,16);
    A(i,33:48) = reshape(t3,1,16);
    A(i,49:64) = reshape(t4,1,16);
end

B = A.'*A;

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

function x = ista(y)
    global A B alpha
    
    temp1 = A.'*y;
    theta = randi(50,[64 1])+150;
    i = 0;
    while true
        i = i+1;
        theta = soft(theta+(temp1-B*theta)/alpha,4/alpha);
        if i > 500
            break
        end
    end
    x = idwt2(reshape(theta(1:16),4,4),reshape(theta(17:32),4,4),reshape(theta(33:48),4,4),reshape(theta(49:64),4,4),'db1');
end

function x = soft(y,alpha)
    x = zeros(size(y));
    x( y >= alpha ) = y( y >= alpha )-alpha;
    x( y <= -alpha ) = y( y <= -alpha )+alpha;
end

%}

