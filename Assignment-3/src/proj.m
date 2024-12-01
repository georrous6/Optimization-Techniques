function x_k_bar = proj(x_k, alpha, beta)
    x_k_bar = zeros(1, length(x_k));
    for i=1:length(x_k)
        if x_k(i) <= alpha(i)
            x_k_bar(i) = alpha(i);
        elseif x_k(i) >= beta(i)
            x_k_bar(i) = beta(i);
        else
            x_k_bar(i) = x_k(i);
        end
    end
end