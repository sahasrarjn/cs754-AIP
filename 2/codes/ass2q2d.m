clc; clear;

X = zeros(100,1);
indices = randperm(100);
X(indices(1:10)) = randi(150,[10 1])+100; 

global A alpha B;

h = [1,2,3,4,3,2,1]/16;

A = zeros(94,100);

for i = 1:94
    A(i,i:i+6) = h;
end

y = A*X + randn(94,1)*norm(X)/20;
B = A.'*A;
alpha = eigs(B,1);

x = ista(y);


function x = ista(y)
    global A B alpha;
    temp1 = A.'*y;
    x = randn([100 1]);
    i = 0;
    while true
        i = i+1;
        x = soft(x+(temp1-B*x)/alpha,20/(alpha));
        if i > 100000
            break;
        end
    end
end

function x = soft(y,alpha)
    x = zeros(size(y));
    x( y >= alpha ) = y( y >= alpha )-alpha;
    x( y <= -alpha ) = y( y <= -alpha )+alpha;
end
