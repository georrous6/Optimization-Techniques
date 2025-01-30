function offspring = mutation(population, N, G, C, V, sigma, tol, max_iters)
    % MUTATION Applies mutation to selected individuals in the population.
    %
    % This function introduces random variations to a subset of the population by adding 
    % noise sampled from a normal distribution (with standard deviation sigma). The mutations
    % are applied iteratively until N feasible individuals are generated or max_iters is reached.
    %
    % INPUTS:
    %   - population  : Matrix (n_edges x population_size) of candidate solutions.
    %   - N           : Number of individuals to mutate.
    %   - G           : Graph adjacency matrix (n_nodes x n_nodes).
    %   - C           : Vector of edge capacity constraints (n_edges x 1).
    %   - V           : Total incoming vehicle flow.
    %   - sigma       : Standard deviation for mutation noise (n_edges x 1).
    %   - tol         : Tolerance for feasibility check.
    %   - max_iters   : Maximum iterations to ensure a feasible mutation.
    %
    % OUTPUT:
    %   - offspring   : Mutated population matrix (same size as input population).

    % Get population size (number of individuals)
    n_points = size(population, 2);

    % Randomly select N individuals for mutation
    mutation_idx = randperm(n_points, N);

    % Copy population to create offspring
    offspring = population;

    % Mutation process
    i = 1;    % Counter for successful mutations
    iter = 0; % Counter for mutation attempts for an individual

    % Apply mutation until N individuals have been mutated
    while i <= N && iter < max_iters
        iter = iter + 1;  % Increment mutation attempt counter

        % Generate a mutated candidate by adding Gaussian noise
        candidate_offspring = offspring(:,mutation_idx(i)) + randn * sigma;

        % Check if the mutated candidate satisfies feasibility constraints
        if is_feasible(G, C, V, candidate_offspring, tol)
            % Accept mutation if feasible
            offspring(:,mutation_idx(i)) = candidate_offspring;
            i = i + 1;  % Move to next individual
            iter = 0;   % Reset iteration counter on successful mutation
        end
    end

    % Warning if mutation process fails to generate a feasible solution
    if iter == max_iters
        warning('Failed to generate a feasible solution after mutation (max_iters=%d)', max_iters);
    end
end