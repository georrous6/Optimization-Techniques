function offspring = mutation(parents, G, C, V, N, sigma, tol)
    
    i = 1;
    [n_features, n_points] = size(parents);
    offspring = zeros(n_features, N);
    while i <= N
        offspring(:,i) = parents(:,randi(n_points, 1, 1)) + sigma .* randn;
        if is_feasible(G, C, V, offspring(:,i), tol)
            i = i + 1;
        end
    end
end