clearvars, clc, close all;
a = -1;
b = 3;

% Specify the folder name to save the plots
outputDir = fullfile('..', 'plots'); % Current directory

% Ensure the directory exists
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % Create the directory if it does not exist
end


%% 1. Golden Section Search: Evaluations vs tolerance

L = linspace(0.002, 0.2, 100);  % holds the tolerances

K = zeros(3, length(L));  % holds the number of iterations
for i = 1:length(L)
    l = L(i);
    [~,~,K(1, i)] = golden_section_search_method(a, b, l, @f1);
    [~,~,K(2, i)] = golden_section_search_method(a, b, l, @f2);
    [~,~,K(3, i)] = golden_section_search_method(a, b, l, @f3);
end

figure(1);
plot(L, K(1,:), 'g:', 'LineWidth', 2, 'DisplayName', 'f1');
hold on;
plot(L, K(2,:), 'b--', 'LineWidth', 2, 'DisplayName', 'f2');
plot(L, K(3,:), 'r-.', 'LineWidth', 2, 'DisplayName', 'f3');
legend show;
xlabel('Tolerance');
ylabel('Evaluations of Objective function');
title('Golden Section Search: Evaluations vs Tolerance');
exportgraphics(gcf, fullfile(outputDir, 'task2_plot1.pdf'));


%% 2. Plot the progression of the interval [a, b] for each of the three functions across multiple tolerances

L = [0.0021, 0.04, 0.14];
colors = ["b", "g", "m"];
legendHandles = gobjects(1, 3); % Array to store plot handles for the legend

figure(2);
sgtitle('Golden Section Search: Bounds Tracking Across Iterations');

% Function 1
subplot(3, 1, 1);
for i = 1:length(L)
    l = L(i);
    [A,B,k] = golden_section_search_method(a, b, l, @f1);
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
    [A,B,k] = golden_section_search_method(a, b, l, @f2);
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
    [A,B,k] = golden_section_search_method(a, b, l, @f3);
    K = 1:k-1;
    hA = plot(K, A, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('l=%.3f', l));
    hold on;
    plot(K, B, 'Color', colors(i), 'LineWidth', 2);
    legendHandles(i) = hA;
end
legend(legendHandles); title('Function 3'); ylabel('Interval [a, b]'); axis tight;
xlabel('Iterations');
exportgraphics(gcf, fullfile(outputDir, 'task2_plot2.pdf'));


function y = f1(x)
    y = (x - 2)^2 + x * log(x + 3);
end

function y = f2(x)
    y = exp(-2 * x) + (x - 2)^2;
end

function y = f3(x)
    y = exp(x) * (x^3 - 1) + (x - 1) * sin(x);
end