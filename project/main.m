clc, clearvars, close all;

seed = randi(1000);
rng(seed);

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
generation_size = 100;
offspring_ratio = 0.9;
mutation_prob = 0.001;
k = 20;
n_generations = 10;
sigma = 0.1 * ones(size(C));

population = C .* rand(size(C, 1), generation_size);

parent_strategy = 'tournament';
[~, objval_tournament, fval_tournament] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

parent_strategy = 'roulette';
[~, objval_roulette, fval_roulette] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

parent_strategy = 'random';
[~, objval_random, fval_random] = minimize_genetic(objective, G, C, V, population, ...
    offspring_ratio, mutation_prob, parent_strategy, k, n_generations, sigma);

%% Plot fitness value over generations for different parent selection strategies
figure;
hold on;
lineWidth = 1.5;
plot(1:n_generations, fval_tournament, '-ob', 'LineWidth', lineWidth);
plot(1:n_generations, fval_roulette, '-og', 'LineWidth', lineWidth);
plot(1:n_generations, fval_random, '-oc', 'LineWidth', lineWidth);
hold off;
legend('tournament', 'roulette', 'random');
xlabel('Generation');
ylabel('Fitness Value');
title('Fitness Value vs generations for different parent selection strategies');

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
ylabel('Objective Value');
title('Objective Value vs generations for different parent selection strategies');
