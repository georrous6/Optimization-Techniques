function offspring = crossover(population, N, G, C, V, tol, parent_strategy, k, fitness_values, max_iters)
    % CROSSOVER Generates offspring using a linear combination of two parents.
    %
    % This function selects two parents from the population using a specified selection strategy
    % and combines their features using a weighted sum (linear crossover). The generated offspring
    % must satisfy feasibility constraints before being included in the new population.
    %
    % INPUTS:
    %   - population      : Matrix (n_features x population_size) of candidate solutions.
    %   - N               : Number of offspring to generate.
    %   - G               : Graph adjacency matrix (n_nodes x n_nodes).
    %   - C               : Vector of edge capacity constraints (n_edges x 1).
    %   - V               : Total incoming vehicle flow.
    %   - tol             : Tolerance for feasibility check.
    %   - parent_strategy : Selection strategy for parents ('tournament', 'roulette', 'random').
    %   - k               : Tournament size (only used in 'tournament' selection).
    %   - fitness_values  : Vector (1 x population_size) of fitness values for parent selection.
    %   - max_iters       : Maximum attempts to generate feasible offspring.
    %
    % OUTPUT:
    %   - offspring       : Matrix (n_features x N) of generated feasible offspring.

    % Get the number of features (edges in the network)
    n_features = size(population, 1);

    % Initialize offspring matrix
    offspring = zeros(n_features, N);

    % Counters for successful offspring and iteration attempts
    i = 1;     % Tracks the number of successfully generated offspring
    iter = 0;  % Tracks total attempts to generate feasible offspring

    % Generate offspring through crossover
    while i <= N && iter < max_iters
        iter = iter + 1;  % Increment iteration counter

        % Select two parents based on the chosen selection strategy
        parent1 = parent_selection(population, parent_strategy, k, fitness_values);
        parent2 = parent_selection(population, parent_strategy, k, fitness_values);

        % Perform crossover using a random weight factor (alpha) between 0 and 1
        alpha = rand;
        offspring(:,i) = alpha * parent1 + (1 - alpha) * parent2;

        % Check feasibility of the newly generated offspring
        if is_feasible(G, C, V, offspring(:,i), tol)
            i = i + 1; % Move to the next offspring
            iter = 0;  % Reset iteration counter on successful addition
        end
    end

    % If max_iters is reached without generating enough feasible offspring, raise an error
    if iter == max_iters
        error('Falied to generate a feasible offspring after crossover (max_iters=%d)', max_iters);
    end
end
