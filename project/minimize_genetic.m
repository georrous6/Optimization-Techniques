function [x_opt, fval] = minimize_genetic(objective, G, C, V, population, offspring_ratio, mutation_ratio, parent_strategy, k, n_generations, tol, sigma, max_iters)

    [n_features, generation_size] = size(population);
    n_offspring = ceil(offspring_ratio * generation_size);
    n_mutation = ceil(mutation_ratio * n_offspring);
    n_old_generation = generation_size - n_offspring;
    
    fval = zeros(1, n_generations);
    x_opt = zeros(n_features, n_generations);
    for i = 1:n_generations

        fitness_values = objective(population);
        fval(i) = min(fitness_values);
        fprintf('Generation %d: fval=%f, size=%d\n', i, fval(i), size(population, 2));
      
        % Generate offspring
        offspring = crossover(population, n_offspring, G, C, V, tol, parent_strategy, k, fitness_values, max_iters);
        offspring = mutation(offspring, n_mutation, G, C, V, sigma, tol, max_iters);

        [~, sorted_indices] = sort(fitness_values);
        x_opt(:,i) = population(:,sorted_indices(1));
        population = [population(:,sorted_indices(1:n_old_generation)), offspring];
    end
end