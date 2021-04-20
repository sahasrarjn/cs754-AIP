function NA=addnoise(A,sz)
% add uniform noise to an image with sz% of the image
% convert to two dimensions
clc;
if sz>100
   disp ('noise size ratio must be 0 to 100') ;
   NA=0;
   return
end
 [h w d]=size(A);
 if d==3
    A=rgb2gray(A);
 end
[h w d]=size(A);
s=h*w*d;
nsz=sz*s/100;

%choose pixels random pixels
r=1:s;
%linear random unique integers
for i=1:s
    rn=round((s-1)*rand(1,1))+1;
    tmp=r(i);
    r(i)=r(rn);
    r(rn)=tmp;
end

%fill with random unifrom noise
%map 1D to 2D row wise 
for i=1:nsz
    xy=r(i);
    y=mod(xy,w);
    if y==0
       y=w; 
       x=floor(xy/w);
    else
       x=floor(xy/w)+1;
    end
   A(x,y)=round(255*rand(1,1));
end
NA=A;
clear A r
