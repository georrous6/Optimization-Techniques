function [x_opt, objval, fval] = minimize_genetic(objective, G, C, V, population, offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma)

    [n_features, generation_size] = size(population);
    n_offspring = ceil(offspring_ratio * generation_size);
    n_old_generation = generation_size - n_offspring;
    offspring = zeros(n_features, n_offspring);
    
    fval = zeros(1, n_generations);
    objval = zeros(1, n_generations);
    lambda = 10;
    for i = 1:n_generations

        fitness_values = objective(population) + lambda * penalty_function(population, G, C, V);
        fval(i) = min(fitness_values);
        objval(i) = min(objective(population));
        fprintf('Generation %d: fitness=%f, objective=%f, lambda=%f, size=%d\n', i, fval(i), objval(i), lambda, size(population, 2));
      
        % Generate offspring by crossover and mutation
        for j = 1:n_offspring
            parent1 = parent_selection(population, parent_strategy, k, fitness_values);
            parent2 = parent_selection(population, parent_strategy, k, fitness_values);

            % Crossover
            alpha = rand;
            offspring(:,j) = alpha * parent1 + (1 - alpha) * parent2;

            % Mutation
            mask = rand(n_features, 1) < mutation_prob;
            offspring(:,j) = offspring(:,j) + mask .* sigma .* randn(n_features, 1);
        end

        % Adjust lambda
        if i > 1
            lambda = lambda + 1 / abs(fval(i) - fval(i - 1));
        end

        [~, sorted_indices] = sort(fitness_values);
        population = [population(:,sorted_indices(1:n_old_generation)), offspring];
    end

    x_opt = population(:, 1);
end