clc; close all; clearvars;

% Define x and y values
xvalues = linspace(-5, 5, 100);
yvalues = linspace(-5, 5, 100);

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

tolerance = 0.0015;  % Gradient tolerance
X0 = [0, -1, 1];  % Starting x values
Y0 = [0, 1, -1];  % Starting y values
iters = [0, 0, 0];  % Holds the number of iterations
colors = {'r', 'g', 'y'};
contourLevels = 30;

% Save the paths for each starting point
xpaths = NaN(3, 10000);
ypaths = NaN(3, 10000);

% Save the value of the cost function on each iteration
costs = NaN(3, 1000);

titleString = '';
% scenario = 'fixed_step';
scenario = 'line_minimization';
% scenario = 'armijo_rule';

switch scenario

    case 'fixed_step'

        gamma = 0.0001;  % Use fixed step
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                grad_norm = norm([dfdx, dfdy]);
                if (grad_norm < tolerance)
                    break;
                end
                x = x - gamma * dfdx / grad_norm;
                y = y - gamma * dfdy / grad_norm;
            end
            fprintf("Fixed step: (x0,y0)=(%d,%d), iterations: %d\n", X0(i), Y0(i), iters(i));
        end
        titleString = sprintf('Gradient Descend Path (Fixed step: %.2f)', gamma);

    case 'line_minimization'

        % Define fibonacci parameters
        l = 0.001;
        e = 0.001;
        distance = 3;
        
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                grad_norm = norm([dfdx, dfdy]);
                if (grad_norm < tolerance || iters(i) > 1000)
                    break;
                end
                xd = @(d) (x - d * dfdx / grad_norm);
                yd = @(d) (y - d * dfdy / grad_norm);
                zd = @(d) (objfunc(xd(d), yd(d)));
                gamma = fibonacci_method(0, distance, l, e, zd);
                x = xd(gamma);
                y = yd(gamma);

                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    dvalues = linspace(0, distance, 100);
                    plot(dvalues, zd(dvalues), 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', X0(i), Y0(i), iters(i), gamma));
                end
            end
            fprintf("Line minimization: (x0,y0)=(%d,%d), iterations: %d\n", X0(i), Y0(i), iters(i));
        end

        titleString = 'Gradient Descend Path (Line Minimization)';

    case 'armijo_rule'

        % Define Armijo rule parameters
        beta = 0.5;  % Denotes how fast the step size changes
        aplha = 0.01;  % Denotes how much improvement do we demand at each step
        s = 3;
        
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                grad_norm = norm([dfdx, dfdy]);
                if (grad_norm < tolerance)
                    break;
                end
                d_k = [-dfdx, -dfdy] / grad_norm;
                gammas = armijo_rule(beta, aplha, s, @objfunc, [dfdx, dfdy], [x, y], d_k);
                gamma = gammas(end);
                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    dvalues = linspace(0, s, 100);
                    cost_values = objfunc(x + dvalues * d_k(1), y + dvalues * d_k(2)) - objfunc(x, y);
                    threshold_line = aplha * [dfdx, dfdy] * d_k' * dvalues;
                    worst_case_line = [dfdx, dfdy] * d_k' * dvalues;
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    plot(dvalues, cost_values, 'Color', 'b', 'LineWidth', 1.5);
                    hold on;
                    plot(dvalues, threshold_line, '--g', 'LineWidth', 1.5);
                    plot(dvalues, worst_case_line, '--m', 'LineWidth', 1.5);
                    plot(gammas, zeros(1, length(gammas)), 'xr', 'MarkerSize', 10, 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', X0(i), Y0(i), iters(i), gamma));
                    hold off;
                end
                x = x - gamma * dfdx / grad_norm;
                y = y - gamma * dfdy / grad_norm;
            end
            fprintf("Armijo Rule: (x0,y0)=(%d,%d), iterations: %d\n", X0(i), Y0(i), iters(i));
        end

        titleString = 'Armijo Rule';
end

% Plot contour lines
figure;
contourf(X, Y, Z, contourLevels);
hold on;
xlabel('X-axis');
ylabel('Y-axis');
title(titleString);
colorbar; % Add a colorbar for reference
for i=1:length(X0)
    xpath = xpaths(i, 1:iters(i));
    ypath = ypaths(i, 1:iters(i));
    plot(xpath, ypath, '--o', 'LineWidth', 1, 'Color', colors{i}, ...
        'DisplayName', sprintf('(x0,y0)=(%d,%d)', X0(i), Y0(i)));
end

legend show;
hold off;
