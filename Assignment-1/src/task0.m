clearvars, clc, close all;
a = -1;
b = 3;

% Specify the folder name to save the plots
outputDir = fullfile('..', 'plots'); % Current directory

% Ensure the directory exists
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % Create the directory if it does not exist
end


%% Calculate the number of iterations for all 4 algorithms
e = 0.001;  % bisection distance for bisection method
L = linspace(2.0001 * e, 200 * e, 100);  % holds the tolerances

K = zeros(4, length(L));  % holds the number of iterations of each method
for i = 1:length(L)
    l = L(i);
    [~,~,K(1, i)] = bisection_method(a, b, l, e, @f1);
    [~,~,K(2, i)] = golden_section_search_method(a, b, l, @f1);
    [~,~,K(3, i)] = fibonacci_method(a, b, l, 0.00001, @f1);
    [~,~,K(4, i)] = bisection_derivitive_method(a, b, l, @df1dx);
end

% Evaluations vs Tolerance for all 4 algorithms
figure(1);
plot(L, 2 * (K(1,:) - 1), 'g-.', 'LineWidth', 2, 'DisplayName', 'Bisection');
hold on;
plot(L, K(2,:), 'b-.', 'LineWidth', 2, 'DisplayName', 'Golden Section Search');
plot(L, K(3,:) + 1, 'r-.', 'LineWidth', 2, 'DisplayName', 'Fibonacci');
plot(L, K(4,:), 'm-.', 'LineWidth', 2, 'DisplayName', 'Bisection Derivitive');
legend show;
xlabel('Tolerance');
ylabel('Evaluations of Objective function');
title('Evaluations vs Tolerance for different optimazation algorithms');
exportgraphics(gcf, fullfile(outputDir, 'task0_plot1.pdf'));

% Iterations vs Tolerance for all 4 algorithms
figure(2);
plot(L, K(1,:) - 1, 'g-.', 'LineWidth', 2, 'DisplayName', 'Bisection');
hold on;
plot(L, K(2,:) - 1, 'b-.', 'LineWidth', 2, 'DisplayName', 'Golden Section Search');
plot(L, K(3,:), 'r-.', 'LineWidth', 2, 'DisplayName', 'Fibonacci');
plot(L, K(4,:) - 1, 'm-.', 'LineWidth', 2, 'DisplayName', 'Bisection Derivitive');
legend show;
xlabel('Tolerance');
ylabel('Iterations');
title('Iterations vs Tolerance for different optimazation algorithms');
exportgraphics(gcf, fullfile(outputDir, 'task0_plot2.pdf'));


function y = f1(x)
    y = (x - 2)^2 + x * log(x + 3);
end

function y = df1dx(x)
    y = 2 * (x - 2) + log(x + 3) + x / (x + 3);
end
   