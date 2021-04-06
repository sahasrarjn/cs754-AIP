close all; clear; clc;

%% Initial run
k = 1;
n = 256;
spar = 16;
eps = [1e3 1e2 1 1e-1 1e-2 1e-3 1e-4 1e-5 1e-6];
sigma=0.01;

for e=eps
    fprintf("\n===== epsilon: %d ======\n", e)
    [f1,f2, rmse1, rmse2] = q1solve(n,spar,k,e,sigma);
    fprintf("RMSE for F1: %d\n", rmse1);
    fprintf("RMSE for F2: %d\n", rmse2);
end




%% (a) Varying \sigma fixed sparsity
k=1;
n=256;
spar=10;
eps = 1e-3;
sigma=[0.0001, 0.0005, 0.001, 0.005, 0.01, 0.02];
% sigma = 0.01:0.01:1;
rmse = zeros(6,2);

i = 1;
for s=sigma
    [f1, f2, rmse1, rmse2] = q1solve(n,spar,k,eps,s);
    rmse(i,1) = rmse1;
    rmse(i,2) = rmse2;
    i = i+1;
end

plot(rmse);
title('Varying sigma, Fixed sparsity (=10)');
legend('RMSE for F1', 'RMSE for F2', 'location', 'northwest');
xticks([1 2 3 4 5 6]);
xticklabels({'0.0001','0.0005','0.001','0.005','0.01','0.02'});
saveas(gcf,'image1.png','png');


%% (b) Varying \sigma fixed sparsity
k=1;
n=256;
spar=[5, 10, 15, 20, 30, 50];
% spar = 5:1:30;
sigma=0.01;
eps = 1e-3;
rmse = zeros(6,2);

i = 1;
for s=spar
    [f1, f2, rmse1, rmse2] = q1solve(n,s,k,eps,sigma);
    rmse(i,1) = rmse1;
    rmse(i,2) = rmse2;
    i = i+1;
end

plot(rmse);
title('Varying sparsity, Fixed sigma (0.01 \times avg(f1+f2))');
legend('RMSE for F1', 'RMSE for F2', 'location', 'northwest');
xticks([1 2 3 4 5 6]);
xticklabels({'5','10','15','20','30','50'});
saveas(gcf,'image2.png','png');



%% (b) Varying k
k=[0.5, 1, 5, 10, 50, 100];
n=256;
spar=10;
eps = 1e-3;
sigma=0.01;
rmse = zeros(6,2);

i = 1;
for s=k
    [f1, f2, rmse1, rmse2] = q1solve(n,spar,s,eps,sigma);
    rmse(i,1) = rmse1;
    rmse(i,2) = rmse2;
    i = i+1;
end

plot(rmse);
title('Varying k (sigma = 0.01 \times avg(f1+f2), sparsity = 10)');
legend('RMSE for F1', 'RMSE for F2', 'location', 'northwest');
xticks([1 2 3 4 5 6]);
xticklabels({'0.5','1','5','10','50','100'});
saveas(gcf,'image3.png','png');

close all;