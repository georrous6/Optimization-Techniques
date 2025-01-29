function [x_opt, objval, pval] = minimize_genetic(objective, G, C, V, population, offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma)

    [n_features, generation_size] = size(population);
    n_offspring = ceil(offspring_ratio * generation_size);
    n_old_generation = generation_size - n_offspring;
    offspring = zeros(n_features, n_offspring);
    
    pval = zeros(1, n_generations);
    objval = zeros(1, n_generations);
    lambda = 1000000;
    for i = 1:n_generations

        penalty_values = penalty_function(population, G, C, V);
        objective_values = objective(population);
        fitness_values = objective_values + lambda * penalty_values;
        pval(i) = min(penalty_values);
        objval(i) = min(objective_values);
        fprintf('Generation %d: penalty=%f, objective=%f, lambda=%f, size=%d\n', i, pval(i), objval(i), lambda, size(population, 2));
      
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
        %lambda = lambda * 2;

        [~, sorted_indices] = sort(fitness_values);
        population = [population(:,sorted_indices(1:n_old_generation)), offspring];
    end

    x_opt = population(:, 1);
end