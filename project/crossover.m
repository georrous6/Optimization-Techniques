function offspring = crossover(parent_pool, N, G, C, V, tol, max_iters)
    
    % Validate input
    [num_features, num_parents] = size(parent_pool);
    if num_parents < 2
        error('Parent pool must contain at least 2 parents.');
    end
            
    offspring = zeros(num_features, N);
    i = 1;
    iter = 0;
    while i <= N && iter < max_iters

        iter = iter + 1;
        % Randomly select two parents from the pool
        parent_indices = randperm(num_parents, 2); % Select two distinct parents
        parent1 = parent_pool(:, parent_indices(1)); % First parent (column vector)
        parent2 = parent_pool(:, parent_indices(2)); % Second parent (column vector)

        offspring(:,i) = (parent1 + parent2) / 2;
        if is_feasible(G, C, V, offspring(:,i), tol)
            iter = 0;
            i = i + 1;
        end
    end

    if iter == max_iters
        warning('Falied to generate a feasible solution after crossover (max_iters=%d)', max_iters);
    end
end
