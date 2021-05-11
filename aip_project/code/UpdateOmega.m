
function updomega=UpdateOmega(M, omega)

    P=omega.*M;
    mn=sum(P,2)./sum(omega,2);
    P=P-mn;
    P=P.^2;
    P=omega.*P;
    v=sqrt(mean(sum(P,2)./sum(omega,2)));
    updomega=omega;
%     imshow(omega,'InitialMagnification',1000); pause();
    M=abs(M-mn);
    updomega(M>2*v)=0;
%     imshow(updomega,'InitialMagnification',1000); pause();
end