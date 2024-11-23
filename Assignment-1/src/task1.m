clearvars, clc, close all;
a = -1;
b = 3;

% Specify the folder name to save the plots
outputDir = fullfile('..', 'plots'); % Current directory

% Ensure the directory exists
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % Create the directory if it does not exist
end

%% 1. Bisection method for constant tolerance and variable bisection distance

l = 0.01; % tolerance
E = linspace(l / 100, l / 2.00001, 100);  % holds the bisection distances
K = zeros(3, length(E));  % holds the number of iterations
for i = 1:length(E)
    e = E(i);
    [~,~,K(1, i)] = bisection_method(a, b, l, e, @f1);
    [~,~,K(2, i)] = bisection_method(a, b, l, e, @f2);
    [~,~,K(3, i)] = bisection_method(a, b, l, e, @f3);
end

figure(1);
plot(E, 2 * (K(1,:) - 1), 'r:', 'LineWidth', 2, 'DisplayName', 'f1');
hold on;
plot(E, 2 * (K(2,:) - 1), 'g--', 'LineWidth', 2, 'DisplayName', 'f2');
plot(E, 2 * (K(3,:) - 1), 'b-.', 'LineWidth', 2, 'DisplayName', 'f3');
legend show;
xlabel('Bisection distance');
ylabel('Evaluations of objective function');
title('Bisection Method: Evaluations vs Bisection Distance');
exportgraphics(gcf, fullfile(outputDir, 'task1_plot1.pdf'));


%% 2. Bisection method for constant bisection distance and variable tolerance
e = 0.001;
L = linspace(2.0001 * e, 200 * e, 100);  % holds the tolerances

K = zeros(3, length(L));  % holds the number of iterations
for i = 1:length(L)
    l = L(i);
    [~,~,K(1, i)] = bisection_method(a, b, l, e, @f1);
    [~,~,K(2, i)] = bisection_method(a, b, l, e, @f2);
    [~,~,K(3, i)] = bisection_method(a, b, l, e, @f3);
end

figure(2);
plot(L, 2 * (K(1,:) - 1), 'g:', 'LineWidth', 2, 'DisplayName', 'f1');
hold on;
plot(L, 2 * (K(2,:) - 1), 'b--', 'LineWidth', 2, 'DisplayName', 'f2');
plot(L, 2 * (K(3,:) - 1), 'r-.', 'LineWidth', 2, 'DisplayName', 'f3');
legend show;
xlabel('Tolerance');
ylabel('Evaluations of objective function');
title('Bisection Method: Evaluations vs Tolerance');
exportgraphics(gcf, fullfile(outputDir, 'task1_plot2.pdf'));


%% 3. Plot the progression of the left and right bounds for each of the three functions across multiple tolerances
e = 0.001;
L = [0.0021, 0.04, 0.14];
colors = ["b", "g", "m"];
legendHandles = gobjects(1, 3); % Array to store plot handles for the legend

figure(3);
sgtitle('Bisection Method: Bounds Tracking Across Iterations');

% Function 1
subplot(3, 1, 1);
for i = 1:length(L)
    l = L(i);
    [A,B,k] = bisection_method(a, b, l, e, @f1);
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
    [A,B,k] = bisection_method(a, b, l, e, @f2);
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
    [A,B,k] = bisection_method(a, b, l, e, @f3);
    K = 1:k-1;
    hA = plot(K, A, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', sprintf('l=%.3f', l));
    hold on;
    plot(K, B, 'Color', colors(i), 'LineWidth', 2);
    legendHandles(i) = hA;
end
legend(legendHandles); title('Function 3'); ylabel('Interval [a, b]'); axis tight;
xlabel('Iterations');
exportgraphics(gcf, fullfile(outputDir, 'task1_plot3.pdf'));


function y = f1(x)
    y = (x - 2)^2 + x * log(x + 3);
end

function y = f2(x)
    y = exp(-2 * x) + (x - 2)^2;
end

function y = f3(x)
    y = exp(x) * (x^3 - 1) + (x - 1) * sin(x);
end