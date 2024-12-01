clc; close all; clearvars;

% Projected Gradient Descend parameters
s_k = 0.1;
gamma_k = 0.2;

x_0 = [8, -10];  % Starting point
epsilon = 0.01;  % Gradient threshold
contourLevels = 20;
max_iters = 1000;  % Maximum number of iterations to converge

% Constraints
x_min = -10;
x_max = 5;
y_min = -8;
y_max = 12;

% Save the paths for each starting point
xpaths = NaN(1, max_iters);
ypaths = NaN(1, max_iters);

% Save the value of the cost function on each iteration
costs = NaN(1, max_iters);
iter = 0;


x_k = x_0;
while true
    iter = iter + 1;
    xpaths(iter) = x_k(1);
    ypaths(iter) = x_k(2);
    costs(iter) = objfunc(x_k(1), x_k(2));

    grad = objfunc_grad(x_k(1), x_k(2));
    norm_grad = norm(grad);
    if norm_grad < epsilon || iter >= max_iters
        break
    end

    x_bar_k = x_k - s_k * grad / norm_grad;
    x_bar_k = proj(x_bar_k, [x_min, y_min], [x_max, y_max]);
    x_k = x_k + gamma_k * (x_bar_k - x_k);
end


% Define the output directory
outputDir = '../plot/';

% Ensure the directory exists
if ~isfolder(outputDir)
    mkdir(outputDir);  % Create the directory if it doesn't exist
end
        
% Define x and y values
xvalues = linspace(-12, 12, 100);
yvalues = linspace(-12, 12, 100);

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
f_handle = @(x) (objfunc(x(1), x(2)));
x_star = fminsearch(f_handle, x_0);
figure;
contourf(X, Y, Z, contourLevels, 'HandleVisibility', 'off');
hold on;
xlabel('X-axis');
ylabel('Y-axis');
title('Projected Gradient Descend: Convergence Paths');
colorbar; % Add a colorbar for reference
plot(xpaths, ypaths, '--go', 'LineWidth', 1.5, ...
    'DisplayName', sprintf('gamma_k=%.1f, s_k=%.1f', gamma_k, s_k));
scatter(x_star(1), x_star(2), 100, 'xm', 'LineWidth', 2, 'DisplayName', 'x*');
legend show;
hold off;

% Save the plot as PDF
filename = 'task4_contour.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);

% Plot convergence progression
f_min = min(Z(:));
figure;
title('Projected Gradient Descend: Convergence vs Iterations');
xvalues = 1:iter;
plot(xvalues, costs(1:iter), 'LineWidth', 1.5, 'Color', 'g', ...
    'DisplayName', sprintf('gamma_k=%.1f, s_k=%.1f', gamma_k, s_k));
hold on;
plot(xvalues, f_min * ones(1, length(xvalues)), '--m', 'LineWidth', 1.5, 'DisplayName', 'min');
hold off;

xlabel('Iterations');
ylabel('Objective Function');
legend show;

% Save the plot as PDF
filename = 'task4_convergence.pdf';
fprintf("Created '%s' at '%s'\n", filename, outputDir);
exportgraphics(gcf, fullfile(outputDir, filename));
% close(gcf);