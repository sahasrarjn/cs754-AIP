
function updomega=Updateomega(M, omega)
    var_vec=var(M,0,2);
    s=sqrt(mean(var_vec));
    updomega=omega;
    mean_vec=mean(M,2);
    M=abs(M-mean_vec);
    updomega(M>2*s)=0;
end