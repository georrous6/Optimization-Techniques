clearvars, clc, close all;
a = -1;
b = 3;

% Specify the folder name to save the plots
outputDir = fullfile('..', 'plots'); % Current directory

% Ensure the directory exists
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % Create the directory if it does not exist
end


%% 1. Bisection Derivitive Method: Evaluations vs tolerance

L = linspace(0.002, 0.2, 100);  % holds the tolerances

K = zeros(3, length(L));  % holds the number of iterations
for i = 1:length(L)
    l = L(i);
    [~,~,K(1, i)] = bisection_derivitive_method(a, b, l, @df1dx);
    [~,~,K(2, i)] = bisection_derivitive_method(a, b, l, @df2dx);
    [~,~,K(3, i)] = bisection_derivitive_method(a, b, l, @df3dx);
end

figure(1);
plot(L, K(1,:), 'g:', 'LineWidth', 2, 'DisplayName', 'f1');
hold on;
plot(L, K(2,:), 'b--', 'LineWidth', 2, 'DisplayName', 'f2');
plot(L, K(3,:), 'r-.', 'LineWidth', 2, 'DisplayName', 'f3');
legend show;
xlabel('Tolerance');
ylabel('Evaluations of objective function');
title('Bisection Derivitive Method: Evaluations vs Tolerance');
exportgraphics(gcf, fullfile(outputDir, 'task4_plot1.pdf'));


%% 2. Plot the progression of the interval [a, b] for each of the three functions across multiple tolerances

L = [0.0021, 0.04, 0.14];
colors = ["b", "g", "m"];
legendHandles = gobjects(1, 3); % Array to store plot handles for the legend

figure(2);
sgtitle('Bisection Derivitive Method: Bounds Tracking Across Iterations');

% Function 1
subplot(3, 1, 1);
for i = 1:length(L)
    l = L(i);
    [A,B,k] = bisection_derivitive_method(a, b, l, @df1dx);
    K = 1:k-1;
    hA = plot(K, A, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('l=%.3f', l));
    hold on;
    plot(K, B, 'Color', colors(i), 'LineWidth', 2);
    legendHandles(i) = hA;
end
legend(legendHandles); title('Function 1'); ylabel('Interval [a, b]'); axis tight;

% Function 2
subplot(3, 1, 2);
for i = 1:length(L)
    l = L(i);
    [A,B,k] = bisection_derivitive_method(a, b, l, @df2dx);
    K = 1:k-1;
    hA = plot(K, A, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('l=%.3f', l));
    hold on;
    plot(K, B, 'Color', colors(i), 'LineWidth', 2);
    legendHandles(i) = hA;
end
legend(legendHandles); title('Function 2'); ylabel('Interval [a, b]'); axis tight;

% Function 3
subplot(3, 1, 3);
for i = 1:length(L)
    l = L(i);
    [A,B,k] = bisection_derivitive_method(a, b, l, @df3dx);
    K = 1:k-1;
    hA = plot(K, A, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('l=%.3f', l));
    hold on;
    plot(K, B, 'Color', colors(i), 'LineWidth', 2);
    legendHandles(i) = hA;
end
legend(legendHandles); title('Function 3'); ylabel('Interval [a, b]'); axis tight;
xlabel('Iterations');
exportgraphics(gcf, fullfile(outputDir, 'task4_plot2.pdf'));


function y = df1dx(x)
    y = 2 * (x - 2) + log(x + 3) + x / (x + 3);
end

function y = df2dx(x)
    y = -2 * exp(-2 * x) + 2 * (x - 2);
end

function y = df3dx(x)
    y = exp(x) * (x^3 - 1 + 3 * x^2) + sin(x) + (x - 1) * cos(x);
end