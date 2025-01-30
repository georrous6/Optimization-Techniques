function parent = parent_selection(population, strategy, k, fitness_values)
    % PARENT_SELECTION Selects a parent from the population based on the given strategy.
    %
    % This function selects an individual from the population for reproduction using one of
    % three selection strategies: tournament selection, roulette wheel selection, or random selection.
    %
    % INPUTS:
    %   - population      : Matrix (n_features x population_size) of candidate solutions.
    %   - strategy        : Parent selection strategy ('tournament', 'roulette', 'random').
    %   - k               : Tournament size (only used in 'tournament' selection).
    %   - fitness_values  : Vector (1 x population_size) of fitness values for the population.
    %
    % OUTPUT:
    %   - parent         : Selected parent individual (n_features x 1).

    % Get the number of individuals in the population
    n_points = size(population, 2);

    % Apply the selected parent selection strategy
    switch strategy
        case 'tournament'
            % Select k random individuals from the population
            tournament_idx = randperm(n_points, k);

            % Find the individual with the best (lowest) fitness value
            [~, idx] = min(fitness_values(tournament_idx));
            parent = population(:, idx);
        case 'roulette'
            % Handle inf values by replacing them with a large finite value
            fitness_values(isinf(fitness_values)) = max(fitness_values(~isinf(fitness_values))) + 1;
            
            % Adjust fitness values for minimization problem (lower is better)
            adjusted_fitness = max(fitness_values) - fitness_values + 1;

            % Normalize probabilities
            probs = adjusted_fitness / sum(adjusted_fitness);
        
            % Compute cumulative probabilities
            cumulative_probs = cumsum(probs);
        
            % Select parent based on roulette wheel selection
            idx = find(cumulative_probs >= rand, 1, 'first');
            parent = population(:,idx);
        case 'random'
            % Select a parent randomly from the population
            parent = population(:,randi(n_points));
        otherwise
            error("Invalid parent selection strategy. Strategies are 'tournament', 'roulette' and 'random'");
    end
end