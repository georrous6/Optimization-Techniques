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
generation_size = 500;
offspring_ratio = 0.9;
mutation_ratio = 0.1;
k = 100;
n_generations = 10;
tol = 1e-3;
sigma = 0.01 * ones(size(C));
max_iters = 10000;
parent_strategies = {'tournament', 'roulette', 'random'};
colors = {'b', 'g', 'c'};
lineWidth = 1.5;
n_features = length(C);
fval_genetic = zeros(3, n_generations);
x_genetic = zeros(n_features, n_generations, 3);

population = explore(G, C, V, generation_size, max_iters);

for i = 1:length(parent_strategies)
    [x_genetic(:,:,i), fval_genetic(i,:)] = minimize_genetic(objective, G, C, V, ...
        population, offspring_ratio, mutation_ratio, parent_strategies{i}, k, ...
        n_generations, tol, sigma, max_iters);
end

%% Plot generations vs convergence of genetic algorithm
figure;
hold on;
for i = 1:length(parent_strategies)
    plot(1:n_generations, fval_genetic(i,:), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
plot(xlim, fval_real * [1, 1], '--r', 'LineWidth', lineWidth);
hold off;
legend(parent_strategies);
xlabel('Generation');
ylabel('Objective value');
title('Convergence of genetic algorithm over generations');

%% Plot Euclidean distance of the solutions from the total minimum
figure;
hold on;
for i = 1:length(parent_strategies)
    plot(1:n_generations, sum((x_real - x_genetic(:,:,i)).^2), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
hold off;
legend('tournament', 'roulette', 'random');
xlabel('Generation');
ylabel('Euclidean Distance');
title('Euclidean distance of solutions from total minimum over generations');

%% Plot local and total minimum values for V +- 15%
generation_size = 100;
n_generations = 10;
k = 100;
n_points = 10;
V_values = linspace(85, 115, n_points);
f_values = zeros(4, n_points);

for i = 1:n_points
    V = V_values(i);

    % Compute total minimum
    x0 = C .* rand(length(C), 1);  % Initial point
    [~, f_values(1,i)] = minimize_linear_conditions(objective, G, C, V, x0);

    % Compute minimum via genetic algorithm
    population = explore(G, C, V, generation_size, max_iters);

    for j = 1:length(parent_strategies)
        [~, fval] = minimize_genetic(objective, G, C, V, ...
            population, offspring_ratio, mutation_ratio, parent_strategies{j}, k, ...
            n_generations, tol, sigma, max_iters);
        f_values(j+1, i) = fval(end);
    end
end

figure;
hold on;
colors = {'r', 'b', 'g', 'c'};
for i = 1:length(parent_strategies) + 1
    plot(V_values, f_values(i,:), '-o', 'Color', colors{i}, 'LineWidth', lineWidth);
end
hold off;
legend([{'builtin function'}, parent_strategies]);
xlabel('V');
ylabel('Objective value');
title('Objective values for different V values');
