function [x_opt, fval] = minimize_genetic(objective, G, C, V, population, offspring_ratio, mutation_ratio, parent_strategy, k, n_generations, tol, sigma, max_iters)
    % MINIMIZE_GENETIC Optimizes the traffic flow using a genetic algorithm.
    %
    % This function uses a genetic algorithm to minimize the objective function related to 
    % traffic flow optimization. It iteratively evolves a population of candidate solutions
    % through selection, crossover, and mutation.
    %
    % INPUTS:
    %   - objective       : Function handle representing the objective function to minimize.
    %   - G               : Graph adjacency matrix (n_nodes x n_nodes).
    %   - C               : Vector of edge capacity constraints (n_edges x 1).
    %   - V               : Total incoming vehicle flow.
    %   - population      : Initial population matrix (n_edges x population_size).
    %   - offspring_ratio : Ratio of offspring generated per generation (0-1).
    %   - mutation_ratio  : Ratio of mutated individuals in the offspring (0-1).
    %   - parent_strategy : Strategy for parent selection ('tournament', 'roulette', 'random').
    %   - k               : Tournament size (only used if 'tournament' selection is chosen).
    %   - n_generations   : Number of generations to run the genetic algorithm.
    %   - tol             : Tolerance for feasibility check.
    %   - sigma           : Standard deviation for mutation noise (n_edges x 1).
    %   - max_iters       : Maximum iterations to ensure feasible solutions.
    %
    % OUTPUTS:
    %   - x_opt           : Best solutions found at each generation (n_edges x n_generations).
    %   - fval            : Objective function values of the best solution per generation.

    % Get population size and feature count (i.e., number of edges)
    [n_features, population_size] = size(population);

    % Compute the number of offspring and mutated individuals per generation
    n_offspring = ceil(offspring_ratio * population_size);  % Number of offspring to create
    n_mutation = ceil(mutation_ratio * n_offspring);        % Number of offspring to mutate
    n_old_generation = population_size - n_offspring;       % Individuals retained from old generation
    
    % Initialize output storage
    fval = zeros(1, n_generations);  % Store best fitness values per generation
    x_opt = zeros(n_features, n_generations);  % Store best solutions per generation

    % Evolution process over generations
    for i = 1:n_generations

        % Evaluate the fitness of the current population
        fitness_values = objective(population);
        fval(i) = min(fitness_values);  % Store the best fitness value
        fprintf('Generation %d: fval=%f, size=%d\n', i, fval(i), size(population, 2));
      
        % Generate offspring through crossover and mutation
        offspring = crossover(population, n_offspring, G, C, V, tol, parent_strategy, k, fitness_values, max_iters);
        offspring = mutation(offspring, n_mutation, G, C, V, sigma, tol, max_iters);

        % Select the best individuals from the current generation
        [~, sorted_indices] = sort(fitness_values);  % Sort by fitness value (ascending)
        x_opt(:,i) = population(:,sorted_indices(1));  % Store the best solution

        % Form the new population combining the best individuals and offspring
        population = [population(:,sorted_indices(1:n_old_generation)), offspring];
    end
end