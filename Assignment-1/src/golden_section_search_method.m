function [A, B, k] = golden_section_search_method(a, b, l, f)
    k = 1;  % Holds the number of iterations
    A = NaN(1, 100);  % Holds the left bound of each iteration
    B = NaN(1, 100);  % Holds the right bound of each iteration
    GR = (sqrt(5) - 1) / 2;  % Golden Ratio
    x1 = a + (1 - GR) * (b - a);
    x2 = a + GR * (b - a);
    y1 = f(x1);
    y2 = f(x2);

    while (b - a) >= l
        A(k) = a;
        B(k) = b;
        if y1 > y2
            a = x1;
            x1 = x2;
            y1 = y2;
            x2 = a + GR * (b - a);
            y2 = f(x2);
        else
            b = x2;
            x2 = x1;
            y2 = y1;
            x1 = a + (1 - GR) * (b - a);
            y1 = f(x1);
        end
        fprintf("k=%d [%f, %f]\n", k, a, b);
        k = k + 1;
    end

    A = A(~isnan(A));
    B = B(~isnan(B));
    fprintf("k=%d [%f, %f]\n", k, a, b);
end