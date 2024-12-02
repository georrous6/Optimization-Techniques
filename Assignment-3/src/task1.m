clc; close all; clearvars;

epsilon = 0.001;  % Gradient threshold
x_0 = [5, -5];  % Starting point
contourLevels = 20;
max_iters = 200;  % Maximum number of iterations to converge

gammas = [0.1, 0.3, 3, 5];  % Step sizes
colors = {'r', 'g', 'k', 'b'};  % Plot colors for each step size

% Save the value of the cost function on each iteration
costs = NaN(4, max_iters);
iters = zeros(1, 4);

% Save the paths for each starting point
xpaths = NaN(4, max_iters);
ypaths = NaN(4, max_iters);

for i=1:length(gammas)
    x_k = x_0;
    while true
        iters(i) = iters(i) + 1;
        xpaths(i, iters(i)) = x_k(1);
        ypaths(i, iters(i)) = x_k(2);
        costs(i, iters(i)) = objfunc(x_k(1), x_k(2));

        grad = objfunc_grad(x_k(1), x_k(2));
        if norm(grad) < epsilon || iters(i) >= max_iters
            break
        end

        x_k = x_k - gammas(i) * grad;
    end

    if iters(i) < max_iters
        fprintf('Converged for gamma=%.2f after %d iterations\n', gammas(i), iters(i));
    else
        fprintf('Failed to converge for gamma=%.2f\n', gammas(i));
    end
end


% Define the output directory
outputDir = '../plot/';

% Ensure the directory exists
if ~isfolder(outputDir)
    mkdir(outputDir);  % Create the directory if it doesn't exist
end
        
% Define x and y values
xvalues = linspace(-10, 5, 100);
yvalues = linspace(-8, 12, 100);

% Create a grid of x and y values
[X, Y] = meshgrid(xvalues, yvalues);

% Evaluate the objective function on the grid
Z = objfunc(X, Y);

% Plot the objective function
figure;
surf(X, Y, Z); % 3D surface plot
xlabel('x');
ylabel('y');
zlabel('z');
title('Objective Function');

% Save the plot as PDF
filename = 'objective_function.pdf';
exportgraphics(gcf, fullfile(outputDir, filename));
fprintf("Created '%s' at '%s'\n", filename, outputDir);
% close(gcf);

% Plot contour lines
x_star = [0, 0];
figure;
contourf(X, Y, Z, contourLevels, 'HandleVisibility', 'off');
hold on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
title('Gradient Descend: Convergence Paths');
colorbar; % Add a colorbar for reference
for i=1:2
    plot(xpaths(i,1:iters(i)), ypaths(i,1:iters(i)), '--o', 'Color', colors{i}, ...
        'LineWidth', 1.5, 'DisplayName', sprintf('$\\gamma_k=%.1f$', gammas(i)));
end
scatter(x_star(1), x_star(2), 100, 'xm', 'LineWidth', 2, 'DisplayName', '$x^*$');
legend('Interpreter', 'latex');
hold off;

% Save the plot as PDF
filename = 'task1_contour.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);


% Plot convergence progression
figure;
sgtitle('Gradient Descend: Convergence vs Iterations');
start_iter = 1;
for i=1:length(gammas)
    xvalues = start_iter:iters(i);
    subplot(4, 1, i);
    plot(xvalues, costs(i, start_iter:iters(i)), 'LineWidth', 1.5, 'Color', colors{i}, ...
        'DisplayName', sprintf('$\\gamma_k=%.1f$', gammas(i)));
    hold on;
    plot(xvalues, zeros(1, length(xvalues)), '--m', 'LineWidth', 1.5, 'DisplayName', 'min');
    hold off;

    xlabel('Iterations');
    ylabel('Cost');
    legend('Interpreter', 'latex');
end

% Save the plot as PDF
filename = 'task1_convergence.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);
