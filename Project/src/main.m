clc, clearvars, close all;

% Define the output directory
outputDir = '../plot/';

% Ensure the directory exists
if ~isfolder(outputDir)
    mkdir(outputDir);  % Create the directory if it doesn't exist
end

% Define edge capacities
C = [54.13; 21.56; 34.08; 49.19; 33.03; ...
     21.84; 29.96; 24.87; 47.24; 33.97; ...
     26.89; 32.76; 39.98; 37.12; 53.83; ...
     61.65; 59.73];

% Define alpha values
alpha = [1.25 * ones(5, 1); 1.5 * ones(5, 1); ones(7, 1)];

% Total incoming vehicle flow
V = 100;

% Construct graph adjacency matrix
% G(i, j) represents the index of the edge connecting node i to node j
G = zeros(9, 9);
G(1, [2, 3, 5, 4]) = [1, 2, 3, 4];
G(2, [7, 6]) = [5, 6];
G(3, [6, 5]) = [7, 8];
G(4, [5, 8]) = [9, 10];
G(5, [8, 9, 6]) = [11, 12, 13];
G(6, [7, 9]) = [14, 15];
G(7, 9) = 16;
G(8, 9) = 17;

% Define objective function to minimize
objective = @(X) (sum(alpha .* X ./ (1 - X ./ C)));

%% Minimize Using Built-in Optimization Function
x0 = C .* rand(length(C), 1);  % Generate initial guess for optimization
[x_real, fval_real] = minimize_linear_conditions(objective, G, C, V, x0);
fprintf('fval (builtin): %f\n', fval_real);
disp('x (builtin):');
disp(x_real);

%% Minimize Using Genetic Algorithm
% Genetic algorithm parameters
population_size = 500;         % Population size
offspring_ratio = 0.9;         % Fraction of population replaced per generation
mutation_ratio = 0.1;          % Fraction of offspring undergoing mutation
k = 100;                       % Tournament size (for tournament selection)
n_generations = 10;            % Number of generations
tol = 1e-3;                    % Feasibility tolerance
sigma = 0.01 * ones(size(C));  % Mutation standard deviation
max_iters = 10000;             % Max attempts for feasibility

% Parent selection strategies for the genetic algorithm
parent_strategies = {'tournament', 'roulette', 'random'};
colors = {'b', 'g', 'c'};  % Colors for plotting
lineWidth = 1.5;

% Initialize storage variables
n_features = length(C);
fval_genetic = zeros(3, n_generations);
x_genetic = zeros(n_features, n_generations, 3);

% Generate Initial Population
population = explore(G, C, V, population_size, max_iters);

% Run Genetic Algorithm for Different Parent Selection Strategies
for i = 1:length(parent_strategies)
    [x_genetic(:,:,i), fval_genetic(i,:)] = minimize_genetic(objective, G, C, V, ...
        population, offspring_ratio, mutation_ratio, parent_strategies{i}, k, ...
        n_generations, tol, sigma, max_iters);
end

%% Plot Convergence of Genetic Algorithm
figure;
hold on;
for i = 1:length(parent_strategies)
    plot(1:n_generations, fval_genetic(i,:), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
plot(xlim, fval_real * [1, 1], '--r', 'LineWidth', lineWidth);
hold off;
legend([parent_strategies, {'built-in solution'}]);
xlabel('Generation');
ylabel('Objective Value');
title('Genetic Algorithm Convergence');

% Save the plot as PDF
filename = 'genetic_convergence.pdf';
exportgraphics(gcf, fullfile(outputDir, filename));
fprintf("Created '%s' at '%s'\n", filename, outputDir);

%% Plot Euclidean Distance from Optimal Solution
figure;
hold on;
for i = 1:length(parent_strategies)
    plot(1:n_generations, sqrt(sum((x_real - x_genetic(:,:,i)).^2)), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
hold off;
legend(parent_strategies);
xlabel('Generation');
ylabel('Euclidean Distance');
title('Distance from Optimal Solution');

% Save the plot as PDF
filename = 'genetic_distance.pdf';
exportgraphics(gcf, fullfile(outputDir, filename));
fprintf("Created '%s' at '%s'\n", filename, outputDir);

%% Sensitivity Analysis for Varying Total Traffic Flow (V +- 15%)
population_size = 100;
n_generations = 10;
k = 100;
n_points = 10;
V_values = linspace(85, 115, n_points);  % Varying V from -15% to +15%
f_values = zeros(4, n_points);

for i = 1:n_points
    V = V_values(i);

    % Compute optimal solution using built-in function
    x0 = C .* rand(length(C), 1);  % Initial point
    [~, f_values(1,i)] = minimize_linear_conditions(objective, G, C, V, x0);

    % Compute solution using genetic algorithm
    population = explore(G, C, V, population_size, max_iters);

    for j = 1:length(parent_strategies)
        [~, fval] = minimize_genetic(objective, G, C, V, ...
            population, offspring_ratio, mutation_ratio, parent_strategies{j}, k, ...
            n_generations, tol, sigma, max_iters);
        f_values(j+1, i) = fval(end);
    end
end

%% Plot Objective Values for Different Total Traffic Flows
figure;
hold on;
colors = {'r', 'b', 'g', 'c'};
for i = 1:length(parent_strategies) + 1
    plot(V_values, f_values(i,:), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
hold off;
legend([{'Built-in Function'}, parent_strategies]);
xlabel('V');
ylabel('Objective Value');
title('Objective Value vs Total Traffic Flow');

% Save the plot as PDF
filename = 'solutions_for_different_traffic_flows.pdf';
exportgraphics(gcf, fullfile(outputDir, filename));
fprintf("Created '%s' at '%s'\n", filename, outputDir);
