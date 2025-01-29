function parent = parent_selection(population, strategy, k, fitness_values)
    n_points = size(population, 2);

    switch strategy
        case 'tournament'
            tournament_idx = randperm(n_points, k);
            [~, idx] = min(fitness_values(tournament_idx));
            parent = population(:, idx);
        case 'roulette'
            % Handle inf values by replacing them with a large finite value
            fitness_values(isinf(fitness_values)) = max(fitness_values(~isinf(fitness_values))) + 1;
            
            % Adjust fitness values for minimization problem
            adjusted_fitness = max(fitness_values) - fitness_values + 1;

            % Normalize probabilities
            probs = adjusted_fitness / sum(adjusted_fitness);
        
            % Compute cumulative probabilities
            cumulative_probs = cumsum(probs);
        
            % Select parent
            idx = find(cumulative_probs >= rand, 1, 'first');
            parent = population(:,idx);
        case 'random'
            parent = population(:,randi(n_points));
        otherwise
            error("Invalid parent selection strategy. Strategies are 'tournament', 'roulette' or 'random'");
    end
end