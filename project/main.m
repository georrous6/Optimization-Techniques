clc, clearvars, close all;

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
objective = @(X) (sum(alpha .* X ./ (1 - X ./ C)));

%% Find the minimum using builtin function
x0 = C .* rand(length(C), 1);  % Initial point
[x_real, fval_real] = minimize_linear_conditions(objective, G, C, V, x0);
fprintf('fval (builtin): %f\n', fval_real);
disp('x (builtin):');
disp(x_real);

%% Find the minimum using a genetic algorithm
generation_size = 100;
crossover_ratio = 0.7;
mutation_ratio = 0.1;
n_generations = 30;
tol = 1e-3;
sigma = 1 * ones(size(C));
[x_genetic, fval_genetic] = minimize_genetic(objective, G, C, V, ...
    generation_size, crossover_ratio, mutation_ratio, n_generations, tol, sigma);
