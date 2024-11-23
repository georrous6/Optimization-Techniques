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

tolerance = 1e-4;  % Gradient tolerance
X0 = [0, -1, 1];  % Starting x values
Y0 = [0, 1, -1];  % Starting y values
iters = [0, 0, 0];  % Holds the number of iterations
colors = {'r', 'g', 'y'};
contourLevels = 30;

% Save the paths for each starting point
xpaths = NaN(3, 1000);
ypaths = NaN(3, 1000);

% Save the value of the cost function on each iteration
costs = NaN(3, 1000);

titleString = '';
% scenario = 'fixed_step';
scenario = 'line_minimization';
% scenario = 'armijo_rule';

switch scenario

    case 'fixed_step'

        step = 0.5;  % Use fixed step
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                if (norm([dfdx, dfdy]) < tolerance)
                    break;
                end
                x = x - step * dfdx;
                y = y - step * dfdy;
            end
            fprintf("Fixed step: (x0,y0)=(%f,%f), iterations: %d\n", X0(i), Y0(i), iters(i));
        end
        titleString = sprintf('Gradient Descend Path (Fixed step: %.2f)', step);

    case 'line_minimization'

        % Define fibonacci parameters
        l = 0.001;
        e = 0.001;
        scaleFactor = 5;
        
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                if (norm([dfdx, dfdy]) < tolerance)
                    break;
                end
                xd = @(d) (x - d * dfdx);
                yd = @(d) (y - d * dfdy);
                zd = @(d) (objfunc(xd(d), yd(d)));
                b = scaleFactor / norm([dfdx, dfdy]);
                step = fibonacci_method(0, b, l, e, zd);
                x = xd(step);
                y = yd(step);

                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    dvalues = linspace(0, b, 100);
                    plot(dvalues, zd(dvalues), 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', X0(i), Y0(i), iters(i), step));
                end
            end
            fprintf("Line minimization: (x0,y0)=(%f,%f), iterations: %d\n", X0(i), Y0(i), iters(i));
        end

        titleString = 'Gradient Descend Path (Line Minimization)';

    case 'armijo_rule'

        % Define Armijo rule parameters
        beta = 0.2;  % Denotes how fast the step size changes
        sigma = 0.1;  % Denotes how much improvement do we demand at each step
        scaleFactor = 5;
        
        for i=1:length(X0)
            x = X0(i);
            y = Y0(i);
            while(true)
                iters(i) = iters(i) + 1;
                xpaths(i,iters(i)) = x;
                ypaths(i,iters(i)) = y;
                [dfdx, dfdy] = grad(x, y);
                if (norm([dfdx, dfdy]) < tolerance)
                    break;
                end
                s = scaleFactor / norm([dfdx, dfdy]); % Set the initial step
                steps = armijo_rule(beta, sigma, s, @objfunc, [dfdx, dfdy], [x, y], [-dfdx, -dfdy]);
                step = steps(end);
                % Visualize the first 3 iterations
                if iters(i) <= 3 && i >= 2
                    dvalues = linspace(0, s, 100);
                    cost_values = objfunc(x - dvalues * dfdx, y - dvalues * dfdy) - objfunc(x, y);
                    threshold_line = -sigma * (dfdx^2 + dfdy^2) * dvalues;
                    worst_case_line = -(dfdx^2 + dfdy^2) * dvalues;
                    subplot(2, 3, iters(i) + (i - 2) * 3);
                    plot(dvalues, cost_values, 'Color', 'b', 'LineWidth', 1.5);
                    hold on;
                    plot(dvalues, threshold_line, '--g', 'LineWidth', 1.5);
                    plot(dvalues, worst_case_line, '--m', 'LineWidth', 1.5);
                    plot(steps, zeros(1, length(steps)), 'xr', 'MarkerSize', 10, 'LineWidth', 1.5);
                    title(sprintf('(x0,y0)=(%d,%d) Iter %d Step: %.2f', X0(i), Y0(i), iters(i), step));
                    hold off;
                end
                x = x - step * dfdx;
                y = y - step * dfdy;
            end
            fprintf("Armijo Rule: (x0,y0)=(%f,%f), iterations: %d\n", X0(i), Y0(i), iters(i));
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
    xpath = xpaths(i, ~isnan(xpaths(i, :)));
    ypath = ypaths(i, ~isnan(ypaths(i, :)));
    plot(xpath, ypath, '--o', 'LineWidth', 1, 'Color', colors{i}, ...
        'DisplayName', sprintf('(x0,y0)=(%d,%d)', X0(i), Y0(i)));
end

legend show;
hold off;
