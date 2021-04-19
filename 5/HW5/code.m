clc; clear;

n=128;
M = [40, 50, 64, 80, 100, 120];

error1=run(M,0,n);
error2=run(M,3,n);

function error=run(M,alpha,n)


    Cov = sigma_x(n,alpha);
    X = mvnrnd(zeros(1,n),Cov,10).'; %'

    error = M;

    for i=1:length(M)
        m = M(i);

        phi = sensing(m,n);

        RMSE = zeros(10,1);
        for j=1:10
            [y, sigma]=measurement(phi,X(:,j));
            est=MAP(Cov, phi, y, sigma);
            RMSE(j)=sqrt(mean((est-X(:,j)).^2));
        end

        error(i) = mean(RMSE);

    end

    figure;
    plot(M,error);
    hold on
    xlabel('m (number of measurements)');
    ylabel('RMSE');
    title(strcat('RMSE vs m for \alpha = ',num2str(alpha)));
    hold off

end

function est=MAP(cov, phi, y, sigma)
    est = (phi.'*phi + sigma^2.*inv(cov))\(phi.'*y);
end

function [y, sigma]=measurement(phi,x)
    y = phi*x;
    m = size(y);
    sigma=0.01*mean(abs(y));
    y = y + sigma*randn(size(y));
end

function phi=sensing(m,n)
    phi = randn(m,n)./sqrt(m);
end

function M=sigma_x (n, alpha)
    U = RandOrthMat(n);
    A = diag(linspace(1,n,n).^(-alpha));
    M = U*A*U.'; %'
end

function M=RandOrthMat(n, tol)

    if nargin==1
	  tol=1e-6;
    end
    
    M = zeros(n);
    vi = randn(n,1);  
    M(:,1) = vi ./ norm(vi);
    
    for i=2:n
	  nrm = 0;
	  while nrm<tol
		vi = randn(n,1);
		vi = vi -  M(:,1:i-1)  * ( M(:,1:i-1).' * vi )  ;
		nrm = norm(vi);
	  end
	  M(:,i) = vi ./ nrm;

    end %i
        
end  % RandOrthMat
