
function updSigma=UpdateSigma(M, Sigma)
    var_vec=var(M,0,2);
    s=sqrt(mean(var_vec));
    updSigma=Sigma;
    mean_vec=mean(M,2);
    M=abs(M-mean_vec);
    updSigma(M>2*s)=0;
end