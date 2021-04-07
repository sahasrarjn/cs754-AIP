close all; clear; clc;

%% Initial run
k = 1;
n = 256;
spar = 16;
eps = [1e3 1e2 1 1e-1 1e-2 1e-3 1e-4 1e-5];
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
sigma = 0.01:0.01:0.5;
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
xlabel("\times avg(f_1 + f_2) \rightarrow");
ylabel("RMSE \rightarrow");
saveas(gcf,'image1.png','png');


%% (b) Varying \sigma fixed sparsity
k=1;
n=256;
% spar=[5, 10, 15, 20, 30, 50];
spar = 5:1:50;
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
xlabel("Sparsity \rightarrow")
ylabel("RMSE \rightarrow");
saveas(gcf,'image2.png','png');



%% (b) Varying k
k = logspace(-2,2);
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

semilogx(k,rmse);
title('Varying k (sigma = 0.01 \times avg(f1+f2), sparsity = 10)');
legend('RMSE for F1', 'RMSE for F2', 'location', 'northwest');
ylabel("RMSE \rightarrow");
xlabel("k \rightarrow")
saveas(gcf,'image3.png','png');
