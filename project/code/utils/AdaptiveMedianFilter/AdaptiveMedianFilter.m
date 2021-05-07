

function [sigma,ModImg]=AdaptiveMedianFilter(img)
    dim = size(img);
    sigma=zeros(dim)+1;
    ModImg=img;

    for i=1:dim(1)
        for j=1:dim(2)
            val=FirstStage(img,i,j,1);
            if val~=img(i,j)
                ModImg(i,j)=val;
                sigma(i,j)=0;
            end
        end
    end

end

function val=FirstStage(img, i, j, Window)
    
    dim = size(img);
    temp = img(max(i-Window,1):min(i+Window,dim(1)),max(j-Window,1):min(j+Window,dim(2)));
    x=img(i,j);
    x_med = median(temp,'all');
    x_min = min(temp,[],'all');
    x_max = max(temp,[],'all');

    if Window==3
        val=x_med;
        return;
    end

    T_neg = x_med-x_min;
    T_pos = x_med-x_max;

    if T_neg>0 && T_pos<0
        if SecondStage(x,x_min,x_max)
            val=x_med;
        else
            val=x;
        end
    else
        val=FirstStage(img, i, j, Window+1);
    end
    
end

function upd=SecondStage(x, x_min, x_max)
    U_neg = x-x_min;
    U_pos = x-x_max;

    if U_neg>0 && U_pos<0
        upd=true;
    else
        upd=false;
    end

end
