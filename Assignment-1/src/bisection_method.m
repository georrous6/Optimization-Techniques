function [A, B, k] = bisection_method(a, b, l, e, f)
    k = 1;  % Holds the number of iterations
    A = NaN(1, 100);  % Holds the left bound of each iteration
    B = NaN(1, 100);  % Holds the right bound of each iteration
    while (b - a) >= l
        A(k) = a;
        B(k) = b;
        x1 = (a + b) / 2 - e;
        x2 = (a + b) / 2 + e;
        if f(x1) < f(x2)
            b = x2;
        else
            a = x1;
        end
        k = k + 1;
    end

    A = A(~isnan(A));
    B = B(~isnan(B));
    fprintf("k=%d [%f, %f]\n", k, a, b);
end