function gammas = armijo_rule(beta, alpha, s, cf, grad_x_k, x_k, d_k)
    % beta       - How fast the step size decreases
    % alpha      - How much improvement we have at each step
    % s          - The starting step
    % cf         - The cost function
    % grad_x_k   - The gradient of the cost function at the starting point
    % x_k        - The starting point
    % d_k        - The direction to search for the appropriate step

    gammas = NaN(1, 100);
    m = 0;
    f_k = cf(x_k(1), x_k(2));
    while true
        gamma = s * beta^m;
        gammas(m + 1) = gamma;
        f_k_plus_1 = cf(x_k(1) + gamma * d_k(1), x_k(2) + gamma * d_k(2));
        if f_k_plus_1 - f_k <= alpha * gamma * grad_x_k * d_k'
            break;
        end
        m = m + 1;
    end

    gammas = gammas(1:m+1);
end