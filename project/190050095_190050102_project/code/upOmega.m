function omega = upOmega(I, thresh, omg)
    I = double(I);
    omega2 = (abs(I - mean(I,2))-thresh);
    omega = omega2 | omg;
end