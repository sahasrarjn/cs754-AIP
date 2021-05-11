% Fixed point iteration for solving the minimization 


function Q=denoise(omega, P)
    %optimization : min (Q) 1/2||Q|omega - P|omega||^2_F + mu ||Q||_*
    %mu = (root(n1) + root(n2))*root(p)*variance
    [n1, n2] = size(P);
    Q=zeros(n1,n2);
    
    omega = uint32(omega);
    P = uint32(P);
    p=uint32(sum(omega,'all'))/uint32(n1*n2);
    
    M=uint32(omega.*P);
    M=M-uint32(sum(M,2)./sum(omega,2));
    M=M.^2;
    M=omega.*M;
%     M
%     imshow(M,[]);
%     pause();
    
    v=sqrt(mean(sum(M,2)./sum(omega,2)));
    
    mu=(sqrt(n1)+sqrt(n2))*sqrt(double(p))*v;
    
    tau=1.5;
    epsilon=1e-5;
    Q = double(Q);
    P = double(P);
    omega = double(omega);
    
    for i=1:50
        R = Q - tau*omega.*(Q-P);
        [U,D,V] = svd(R);
        D = max(D-tau*mu,0);
        Temp = U*D*V.';
        if norm(Temp-Q, 'fro') <= epsilon
            Q = Temp;
            break;
        end
        Q = Temp;
    end
    Q = uint32(Q);
end