
function Q=denoise(omega, P)
    %optimization : min (Q) 1/2||Q|omega - P|omega||^2_F + mu ||Q||_*
    %mu = (root(n1) + root(n2))*root(p)*variance
    [n1, n2] = size(P);
    Q=zeros(n1,n2);
    
    p=sum(omega,'all')/(n1*n2);
    
    M=omega.*P;
    M=M-sum(M,2)./sum(omega,2);
    M=M.^2;
    M=omega.*M;
    v=sqrt(mean(sum(M,2)./sum(omega,2)));
    
    mu=(sqrt(n1)+sqrt(n2))*sqrt(p)*v;
    
    tau=1.5;
    epsilon=1e-5;
    
    for i=1:30
        R = Q - tau*omega.*(Q-P);
        [U,D,V] = svd(R);
        D = max(D-tau*mu,0);
        Temp = U*D*V.';
        if norm(Temp-Q) <= epsilon
            Q = Temp;
            break;
        end
    end
end