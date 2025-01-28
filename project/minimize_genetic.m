function [x_opt, fval] = minimize_genetic(objective, G, C, V, generation_size, offspring_ratio, mutation_ratio, n_generations, tol, sigma, max_iters)
    if size(C, 2) ~= 1
        error('<C> must be a column vector');
    end
    if size(sigma) ~= size(C)
        error('<C> and <sigma> must have the same dimensions and must be column vectors');
    end
    if offspring_ratio > 1 || offspring_ratio <= 0
        error('Invalid input for <offspring_ratio> (0 < offspring_ratio <= 1)');
    end
    if mutation_ratio > 1 || mutation_ratio <= 0
        error('Invalid input for <mutation_ratio> (0 < mutation_ratio <= 1)');
    end

    % Get random initial solutions that satisfy the constraints
    x0 = generate_initial_solutions(G, C, V, generation_size, max_iters);

    x = x0;

    n_offspring = ceil(offspring_ratio * generation_size);
    n_mutation = ceil(mutation_ratio * n_offspring);
    n_parents = generation_size - n_offspring;
    
    fval = zeros(1, n_generations);
    for i = 1:n_generations

        fitness_values = objective(x);
        [fitness_values, sorted_indices] = sort(fitness_values);

        x = x(:,sorted_indices);
        fval(i) = fitness_values(1);
        fprintf('Generation %d: fval=%f, size=%d\n', i, fval(i), size(x, 2));
      
        % Generate offspring
        offspring = crossover(x, n_offspring, G, C, V, tol, max_iters);
        offspring = mutation(offspring, n_mutation, G, C, V, sigma, tol, max_iters);

        x = [x(:,1:n_parents), offspring];
    end

    x_opt = x(:, 1);
end