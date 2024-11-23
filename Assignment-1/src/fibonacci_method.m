function [A, B, k] = fibonacci_method(a, b, l, e, f)
    k = 1;  % Holds the number of iterations
    A = NaN(1, 100);  % Holds the left bound of each iteration
    B = NaN(1, 100);  % Holds the right bound of each iteration
    fib = NaN(1, 100);  % Reserve space for the fibonacci numbers
    
    % Compute the number of iterations
    fib(1) = 1;
    fib(2) = 1;
    n = 2;
    while (fib(n) <= (b - a) / l)
        n = n + 1;
        fib(n) = fib(n - 1) + fib(n - 2);
    end

    fprintf('n=%d\n', n);
    x1 = a + fib(n - 2) / fib(n) * (b - a);
    x2 = a + fib(n - 1) / fib(n) * (b - a);
    y1 = f(x1);
    y2 = f(x2);

    while k < (n - 2)
        A(k) = a;
        B(k) = b;
        if y1 > y2
            a = x1;
            x1 = x2;
            y1 = y2;
            x2 = a + fib(n - k - 1) / fib(n - k) * (b - a);
            y2 = f(x2);
        else
            b = x2;
            x2 = x1;
            y2 = y1;
            x1 = a + fib(n - k - 2) / fib(n - k) * (b - a);
            y1 = f(x1);
        end
        % fprintf("k=%d [%f, %f]\n", k, a, b);
        k = k + 1;
    end

    % final estimation of bounds
    x2 = x1 + e;
    if f(x1) > f(x2)
        A(k) = x1;
        B(k) = b;
    else
        A(k) = a;
        B(k) = x2;
    end

    A = A(~isnan(A));
    B = B(~isnan(B));
    fprintf("k=%d [%f, %f]\n", k, a, b);
end