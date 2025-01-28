function offspring = crossover(parent_pool, N, G, C, V, tol)
    
    % Validate input
    [num_features, num_parents] = size(parent_pool);
    if num_parents < 2
        error('Parent pool must contain at least 2 parents.');
    end
            
    offspring = zeros(num_features, N);
    i = 1;
    while i <= N
        % Randomly select two parents from the pool
        parent_indices = randperm(num_parents, 2); % Select two distinct parents
        parent1 = parent_pool(:, parent_indices(1)); % First parent (column vector)
        parent2 = parent_pool(:, parent_indices(2)); % Second parent (column vector)

        offspring(:,i) = (parent1 + parent2) / 2;
        if is_feasible(G, C, V, offspring(:,i), tol)
            i = i + 1;
        end
    end
end
