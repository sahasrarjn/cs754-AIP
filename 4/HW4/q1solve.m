function [fo1, fo2, rmse1, rmse2] = q1solve(n,spar,k,eps, sigma_k)
    % Generating f1
    f1 = zeros(n,1);
    idx = randi(n,spar,1);
    val =  randi(10,spar,1);
    f1(idx) = val;
    A1 = dctmtx(n);
    f1 = A1*f1;
    
    % Generating f2
    f2 = zeros(n,1);
    idx = randi(n,spar,1);
    val = randi(10,spar,1);
    f2(idx)=val;
    f2 = k*f2;
    A2 = eye(n);
    
    % Generating noise
    sigma = sigma_k*mean(f1+f2,'all');
    gm = gmdistribution(0,sigma);
    eta = random(gm,n);
    
    
    % Reconstruction
    f = f1+f2+eta;
    A = [A1 A2];
    
    theta = l1_ls(A,f,eps,eps,true);
    fo1 = A1*theta(1:n,:);
    fo2 = A2*theta(n+1:2*n,:);
    
    rmse1 = norm(fo1-f1)/norm(f1);
    rmse2 = norm(fo2-f2)/norm(f2);
end



