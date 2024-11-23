function [A, B, k] = bisection_derivitive_method(a, b, l, dfdx)
    k = 1;  % Holds the number of iterations
    A = NaN(1, 100);  % Holds the left bound of each iteration
    B = NaN(1, 100);  % Holds the right bound of each iteration
    
    % Compute the number of iterations
    n = ceil(log2((b - a) / l));  % Calculates the required iterations

    fprintf('n=%d\n', n);

    while k <= n
        A(k) = a;
        B(k) = b;
        x = (a + b) / 2;
        y = dfdx(x);
        if y > 0
            b = x;
        elseif y < 0
            a = x;
        else
            break;
        end
        % fprintf("k=%d [%f, %f]\n", k, a, b);
        k = k + 1;
    end

    A = A(~isnan(A));
    B = B(~isnan(B));
    fprintf("k=%d [%f, %f]\n", k, a, b);
end