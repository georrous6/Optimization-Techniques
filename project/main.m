clc, clearvars, close all;

seed = randi(1000);
rng(546);

% Edges capacities
C = [54.13; 21.56; 34.08; 49.19; 33.03; ...
     21.84; 29.96; 24.87; 47.24; 33.97; ...
     26.89; 32.76; 39.98; 37.12; 53.83; ...
     61.65; 59.73];

alpha = [1.25 * ones(5, 1); 1.5 * ones(5, 1); ones(7, 1)];
V = 100;

% Graph construction
G = zeros(9, 9);
G(1, [2, 3, 5, 4]) = [1, 2, 3, 4];
G(2, [7, 6]) = [5, 6];
G(3, [6, 5]) = [7, 8];
G(4, [5, 8]) = [9, 10];
G(5, [8, 9, 6]) = [11, 12, 13];
G(6, [7, 9]) = [14, 15];
G(7, 9) = 16;
G(8, 9) = 17;

% Objective function to minimize
objective = @(x) (sum(alpha .* x ./ (1 - x ./ C)));

%% Find the minimum using builtin function
x0 = C .* rand(length(C), 1);  % Initial point
[x_real, objval_real] = minimize_linear_conditions(objective, G, C, V, x0);
fprintf('fval (builtin): %f\n', objval_real);
disp('x (builtin):');
disp(x_real);

%% Find the minimum using a genetic algorithm
generation_size = 1000;
offspring_ratio = 0.9;
mutation_prob = 0.001;
k = 100;
n_generations = 20;
sigma = 1.0 * ones(size(C));
max_iters = 1000;

population = explore(G, C, V, generation_size, max_iters);

parent_strategy = 'tournament';
[x_tournament, objval_tournament, pval_tournament] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

parent_strategy = 'roulette';
[x_roulette, objval_roulette, pval_roulette] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

parent_strategy = 'random';
[x_random, objval_random, pval_random] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

%% Plot penalty vs generations for different parent selection strategies
figure;
hold on;
lineWidth = 1.5;
plot(1:n_generations, pval_tournament, '-ob', 'LineWidth', lineWidth);
plot(1:n_generations, pval_roulette, '-og', 'LineWidth', lineWidth);
plot(1:n_generations, pval_random, '-oc', 'LineWidth', lineWidth);
hold off;
legend('tournament', 'roulette', 'random');
xlabel('Generation');
ylabel('Penalty');
title('Penalty vs Generations for different parent selection strategies');

%% Plot objective value over generations for different parent selection strategies
figure;
hold on;
lineWidth = 1.5;
plot(1:n_generations, objval_tournament, '-ob', 'LineWidth', lineWidth);
plot(1:n_generations, objval_roulette, '-og', 'LineWidth', lineWidth);
plot(1:n_generations, objval_random, '-oc', 'LineWidth', lineWidth);
plot(xlim, objval_real * [1, 1], '--r', 'LineWidth', lineWidth);
hold off;
legend('tournament', 'roulette', 'random');
xlabel('Generation');
ylabel('Objective');
title('Objective vs Generations for different parent selection strategies');
