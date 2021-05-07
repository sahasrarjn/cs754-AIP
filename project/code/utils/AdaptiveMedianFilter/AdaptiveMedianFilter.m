

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
        if SecondStage(x,x_min,x_max)
            val=x_med;
        else
            val=x;
        end 
        return;
    end

    T_neg = x_med-x_min;
    T_pos = x_med-x_max;

    H_1 = x_med==0;
    H_2 = x_med==255;
    H_3 = 0<x_med && x_med<255;

    if T_neg==0 && T_pos==0
        if (H_1&&~H_2&&~H_3) || (H_2&&~H_1&&~H_3) || (H_3&&~H_2&&~H_1)
            if SecondStage(x,x_min,x_max)
                val=x_med;
            else
                val=x;
            end
        else
            val=FirstStage(img, i, j, Window+1);
        end
    elseif T_neg==0 && T_pos<0
        if bitxor(H_1,H_3)
            if SecondStage(x,x_min,x_max)
                val=x_med;
            else
                val=x;
            end
        else
            val=FirstStage(img, i, j, Window+1);
        end
    elseif T_neg>0 && T_pos==0
        if bitxor(H_2,H_3)
            if SecondStage(x,x_min,x_max)
                val=x_med;
            else
                val=x;
            end
        else
            val=FirstStage(img, i, j, Window+1);
        end
    else
       if SecondStage(x,x_min,x_max)
            val=x_med;
        else
            val=x;
        end 
    end
    
end

function upd=SecondStage(x, x_min, x_max)
    U_neg = x-x_min;
    U_pos = x-x_max;

    E_1 = x==0;
    E_2 = x==255;
    E_3 = 0<x && x<255;

    if U_neg==0 && U_pos==0
        upd=true;
    elseif U_neg==0 && U_pos<0
        if bitxor(E_1,E_3)
            upd=false;
        else
            upd=true;
        end
    elseif U_neg>0 && U_pos==0
        if bitxor(E_2,E_3)
            upd=false;
        else
            upd=true;
        end
    else
        upd=false;
    end

end