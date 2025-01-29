function offspring = mutation(population, N, G, C, V, sigma, tol, max_iters)

    [n_points, ~] = size(population);
    mutation_idx = randperm(n_points, N);
    offspring = population;
    i = 1;
    iter = 0;
    while i <= N && iter < max_iters
        iter = iter + 1;
        candidate_offspring = offspring(:,mutation_idx(i)) + randn * sigma;
        if is_feasible(G, C, V, candidate_offspring, tol)
            offspring(:,mutation_idx(i)) = candidate_offspring;
            i = i + 1;
            iter = 0;
        end
    end

    if iter == max_iters
        warning('Failed to generate a feasible solution after mutation (max_iters=%d)', max_iters);
    end
end