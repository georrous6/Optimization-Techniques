clc; close all; clearvars;

% Projected Gradient Descend parameters
s_ks = [0.1, 2];
gamma_k = 0.2;

x_0 = [8, -10];  % Starting point
epsilon = 0.01;  % Gradient threshold
contourLevels = 20;
max_iters = 1000;  % Maximum number of iterations to converge
colors = {'r', 'g'};

% Constraints
x_min = -10;
x_max = 5;
y_min = -8;
y_max = 12;

% Save the paths for each case
xpaths = NaN(length(s_ks), max_iters);
ypaths = NaN(length(s_ks), max_iters);

% Save the value of the cost function on each iteration
costs = NaN(length(s_ks), max_iters);

% Save the number of iterations for each case
iters = zeros(length(s_ks), 1);

for i=1:length(s_ks)
    iter = 0;
    x_k = x_0;
    while true
        iter = iter + 1;
        iters(i,1) = iter;
        xpaths(i, iter) = x_k(1);
        ypaths(i, iter) = x_k(2);
        costs(i, iter) = objfunc(x_k(1), x_k(2));
    
        grad = objfunc_grad(x_k(1), x_k(2));
        if norm(grad) < epsilon || iter >= max_iters
            break
        end
    
        s_k = s_ks(i);
        x_bar_k = x_k - s_k * grad;
        x_bar_k = proj(x_bar_k, [x_min, y_min], [x_max, y_max]);
        x_k = x_k + gamma_k * (x_bar_k - x_k);
    end
    
    if iter < max_iters
        fprintf('Converged successfully for gamma=%.1f, s_k=%.1f after %d iterations\n', gamma_k, s_k, iter);
    else
        fprintf('Failed to converge for gamma=%.1f, s_k=%.1f\n', gamma_k, s_k);
    end
end


% Define the output directory
outputDir = '../plot/';

% Ensure the directory exists
if ~isfolder(outputDir)
    mkdir(outputDir);  % Create the directory if it doesn't exist
end
        
% Define x and y values
xvalues = linspace(-10, 10, 100);
yvalues = linspace(-12, 12, 100);

% Create a grid of x and y values
[X, Y] = meshgrid(xvalues, yvalues);

% Evaluate the objective function on the grid
Z = objfunc(X, Y);

% Plot contour lines
x_star = [0, 0];
figure;
contourf(X, Y, Z, contourLevels, 'HandleVisibility', 'off');
hold on;

% Plot feasible region
width = x_max - x_min;
height = y_max - y_min;
rectangle('Position', [x_min y_min width height], 'EdgeColor', ...
    'k', 'LineWidth', 2, 'LineStyle', '--');

xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
title('Projected Gradient Descend: Convergence Paths');
colorbar; % Add a colorbar for reference
for i=1:length(s_ks)
    xpath = xpaths(i, 1:iters(i,1));
    ypath = ypaths(i, 1:iters(i,1));
    plot(xpath, ypath, '--o', 'LineWidth', 1.5, 'Color', colors{i}, ...
        'DisplayName', sprintf('$\\gamma_k=%.1f, s_k=%.1f$', gamma_k, s_ks(i)));
end
scatter(x_star(1), x_star(2), 100, 'xm', 'LineWidth', 2, 'DisplayName', '$x^*$');
legend('Interpreter', 'latex');
hold off;

% Save the plot as PDF
filename = 'task4_contour.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);

% Plot convergence progression
figure;
sgtitle('Projected Gradient Descend: Convergence vs Iterations');
for i=1:length(s_ks)
    xvalues = 1:iters(i,1);
    subplot(2, 1, i);
    plot(xvalues, costs(i, 1:iters(i,1)), 'LineWidth', 1.5, 'Color', colors{i}, ...
        'DisplayName', sprintf('$\\gamma_k=%.1f, s_k=%.1f$', gamma_k, s_ks(i)));
    hold on;
    plot(xvalues, zeros(1, length(xvalues)), '--m', 'LineWidth', 1.5, 'DisplayName', 'min');
    hold off;

    xlabel('Iterations');
    ylabel('Cost');
    legend('Interpreter', 'latex');
end

% Save the plot as PDF
filename = 'task4_convergence.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);
