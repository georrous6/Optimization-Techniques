function [x_opt, fval] = minimize_genetic(objective, G, C, V, generation_size, crossover_ratio, mutation_ratio, n_generations, tol, sigma)
    if size(C, 2) ~= 1
        error('<C> must be a column vector');
    end
    if size(sigma) ~= size(C)
        error('<C> and <sigma> must have the same dimensions and must be column vectors');
    end
    
    % Get random initial solutions that satisfy the constraints
    x0 = generate_initial_solutions(G, C, V, generation_size);

    x = x0;

    n_crossover = floor(crossover_ratio * generation_size);
    n_mutation = floor(mutation_ratio * generation_size);
    n_parents = generation_size - n_crossover - n_mutation;
    
    fval = zeros(1, n_generations);
    for i = 1:n_generations

        fitness_values = objective(x);
        [fitness_values, sorted_indices] = sort(fitness_values);

        x = x(:,sorted_indices);
        fval(i) = fitness_values(1);
        fprintf('Generation %d: fval=%f, size=%d\n', i, fval(i), size(x, 2));
      
        % Generate offspring
        offspring_crossover = crossover(x, n_crossover, G, C, V, tol);
        offspring_mutation = mutation(x, G, C, V, n_mutation, sigma, tol);

        x = [x(:,1:n_parents), offspring_crossover, offspring_mutation];
    end

    x_opt = x(:, 1);
end