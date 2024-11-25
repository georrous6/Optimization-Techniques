clc; close all; clearvars;

% Define x and y values
xvalues = linspace(-4, 4, 100);
yvalues = linspace(-4, 4, 100);

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

epsilon = 0.0015;  % Gradient tolerance
x_0 = [0, 0; -1, 1; 1, -1];  % Starting points
iters = [0, 0, 0];  % Holds the number of iterations
colors = {'r', 'g', 'y'};
contourLevels = 20;
max_iters = 10000;

% Save the paths for each starting point
xpaths = NaN(3, max_iters);
ypaths = NaN(3, max_iters);

% Save the value of the cost function on each iteration
costs = NaN(3, max_iters);

titleString = '';
scenario = 'fixed_step';
% scenario = 'line_minimization';
% scenario = 'armijo_rule';

switch scenario

    case 'fixed_step'

        gamma = 0.001;  % Use fixed step
        for i=1:size(x_0, 1)
            x_k = x_0(i,:);
            while true
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x_k(1);
                ypaths(i,iters(i)) = x_k(2);
                costs(i,iters(i)) = objfunc(x_k(1), x_k(2));
                grad = objfunc_grad(x_k(1), x_k(2));
                grad_norm = norm(grad);
                d_k = -grad / grad_norm;
                if grad_norm < epsilon || iters(i) >= max_iters
                    break;
                end
                x_k = x_k + gamma * d_k;
            end
            fprintf("Fixed step: (x0,y0)=(%d,%d), iterations: %d\n", x_0(i, 1), x_0(i, 2), iters(i));
        end
        titleString = sprintf('Gradient Descend Path (Fixed step: %.2f)', gamma);

    case 'line_minimization'

        % Define fibonacci parameters
        l = 0.001;
        e = 0.001;
        distance = 3;
        
        for i=1:size(x_0, 1)
            x_k = x_0(i,:);
            while true
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x_k(1);
                ypaths(i,iters(i)) = x_k(2);
                costs(i,iters(i)) = objfunc(x_k(1), x_k(2));
                grad = objfunc_grad(x_k(1), x_k(2));
                grad_norm = norm(grad);
                d_k = -grad / grad_norm;
                if grad_norm < epsilon || iters(i) >= max_iters
                    break;
                end
                xd = @(d) (x_k(1) + d * d_k(1));
                yd = @(d) (x_k(2) + d * d_k(2));
                zd = @(d) (objfunc(xd(d), yd(d)));
                gamma = fibonacci_method(0, distance, l, e, zd);
                x_k(1) = xd(gamma);
                x_k(2) = yd(gamma);

                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    dvalues = linspace(0, distance, 100);
                    plot(dvalues, zd(dvalues), 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', x_0(i,1), x_0(i,2), iters(i), gamma));
                end
            end
            fprintf("Line minimization: (x0,y0)=(%d,%d), iterations: %d\n", x_0(i,1), x_0(i,2), iters(i));
        end

        titleString = 'Gradient Descend Path (Line Minimization)';

    case 'armijo_rule'

        % Define Armijo rule parameters
        beta = 0.5;  % Denotes how fast the step size changes
        aplha = 0.01;  % Denotes how much improvement do we demand at each step
        s = 3;
        
        for i=1:size(x_0, 1)
            x_k = x_0(i,:);
            while true
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x_k(1);
                ypaths(i,iters(i)) = x_k(2);
                costs(i,iters(i)) = objfunc(x_k(1), x_k(2));
                grad = objfunc_grad(x_k(1), x_k(2));
                grad_norm = norm(grad);
                d_k = -grad / grad_norm;
                if grad_norm < epsilon || iters(i) >= max_iters
                    break;
                end
                gammas = armijo_rule(beta, aplha, s, @objfunc, grad, x_k, d_k);
                gamma = gammas(end);
                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    dvalues = linspace(0, s, 100);
                    cost_values = objfunc(x_k(1) + dvalues * d_k(1), x_k(2) + dvalues * d_k(2)) - objfunc(x_k(1), x_k(2));
                    threshold_line = aplha * grad * d_k' * dvalues;
                    worst_case_line = grad * d_k' * dvalues;
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    plot(dvalues, cost_values, 'Color', 'b', 'LineWidth', 1.5);
                    hold on;
                    plot(dvalues, threshold_line, '--g', 'LineWidth', 1.5);
                    plot(dvalues, worst_case_line, '--m', 'LineWidth', 1.5);
                    plot(gammas, zeros(1, length(gammas)), 'xr', 'MarkerSize', 10, 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', x_0(i,1), x_0(i,2), iters(i), gamma));
                    hold off;
                end
                x_k = x_k + gamma * d_k;
            end
            fprintf("Armijo Rule: (x0,y0)=(%d,%d), iterations: %d\n", x_0(i,1), x_0(i,2), iters(i));
        end

        titleString = 'Gradient Descend Path (Armijo Rule)';
end

% Plot contour lines
figure;
contourf(X, Y, Z, contourLevels, 'HandleVisibility', 'off');
hold on;
xlabel('X-axis');
ylabel('Y-axis');
title(sprintf('%s: Convergence Paths', titleString));
colorbar; % Add a colorbar for reference
for i=1:size(x_0, 1)
    xpath = xpaths(i, 1:iters(i));
    ypath = ypaths(i, 1:iters(i));
    plot(xpath, ypath, '--o', 'LineWidth', 1.5, 'Color', colors{i}, ...
        'DisplayName', sprintf('(x0,y0)=(%d,%d)', x_0(i,1), x_0(i,2)));
end

legend show;
hold off;

% Plot cost function progression
f_min = min(Z(:));
figure;
sgtitle(sprintf('%s: Cost Function Progression', titleString));
for i=1:size(x_0, 1)
    xvalues = 1:iters(i);
    subplot(3, 1, i);
    plot(xvalues, costs(i, 1:iters(i)),'-o', 'LineWidth', 1.5, 'Color', colors{i}, ...
        'DisplayName', sprintf('(x0,y0)=(%d,%d)', x_0(i,1), x_0(i,2)));
    hold on;
    plot(xvalues, f_min * ones(1, iters(i)), '--m', 'LineWidth', 1.5, 'DisplayName', 'min');
    hold off;

    xlabel('Iterations');
    ylabel('Cost Function');
    legend show;
end
