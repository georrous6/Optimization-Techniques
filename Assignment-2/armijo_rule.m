function steps = armijo_rule(beta, sigma, s, cf, grad_x_k, x_k, d_k)
    % beta       - How fast the step size decreases
    % sigma      - How much improvement we have at each step
    % s          - The starting step
    % cf         - The cost function
    % grad_x_k   - The gradient of the cost function at the starting point
    % x_k        - The starting point
    % d_k        - The directionto search for the appropriate step

    steps = NaN(1, 100);
    i = 1;
    step = s;
    f_k = cf(x_k(1), x_k(2));
    while true
        f_k_plus_1 = cf(x_k(1) + step * d_k(1), x_k(2) + step * d_k(2));
        steps(i) = step;
        if f_k_plus_1 - f_k <= sigma * step * grad_x_k * d_k'
            break;
        end
        step = step * beta;
        i = i + 1;
    end

    steps = steps(~isnan(steps));
end