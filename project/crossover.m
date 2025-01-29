function offspring = crossover(population, N, G, C, V, tol, parent_strategy, k, fitness_values, max_iters)

    n_features = size(population, 1);
    offspring = zeros(n_features, N);
    i = 1;
    iter = 0;
    while i <= N && iter < max_iters
        iter = iter + 1;
        parent1 = parent_selection(population, parent_strategy, k, fitness_values);
        parent2 = parent_selection(population, parent_strategy, k, fitness_values);
        alpha = rand;
        offspring(:,i) = alpha * parent1 + (1 - alpha) * parent2;  % crossover
        if is_feasible(G, C, V, offspring(:,i), tol)
            i = i + 1;
            iter = 0;
        end
    end

    if iter == max_iters
        error('Falied to generate a feasible offspring after crossover (max_iters=%d)', max_iters);
    end
end
