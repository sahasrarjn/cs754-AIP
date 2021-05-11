function omega = upOmega(I, thresh)
    I = double(I);
    omega = (abs(I - mean(I,2))-thresh);
end