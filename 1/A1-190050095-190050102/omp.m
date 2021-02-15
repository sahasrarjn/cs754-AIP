function theta = omp(A,b,epsilon)
    r = b;
    N = size(A,2);
    theta = zeros(N,1);
    T = [];
    i = 0;
    A_nor =  normc(A);
    
    while norm(r)*norm(r)>epsilon
        [~, idx] = max(abs(r'*A_nor));
        T = [T idx];
        i = i + 1;
        x = A(:,T)\b;
        r = b - A(:,T) * x;
        theta(T) = x;
    end
end