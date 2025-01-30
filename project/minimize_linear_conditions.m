function [x, fval] = minimize_linear_conditions(objective, G, C, V, x0)
    % MINIMIZE_LINEAR_CONDITIONS Solves the optimization problem for vehicle flow in a network.
    %
    % This function minimizes the total travel time in a road network by 
    % optimizing the vehicle flow using linear equality constraints.
    %
    % Inputs:
    %   - objective : Function handle representing the objective function.
    %   - G         : Adjacency matrix representing the road network.
    %   - C         : Vector of maximum vehicle flow capacities for each edge.
    %   - V         : Total incoming vehicle flow into the network.
    %   - x0        : Initial guess for the optimization variables.
    %
    % Outputs:
    %   - x         : Optimized flow distribution across the edges.
    %   - fval      : Final value of the objective function.

    % Number of nodes and edges in the network
    n_nodes = size(G, 1);
    n_edges = length(C);
    
    % Initialize equality constraint matrices (flow conservation)
    A_eq = zeros(n_nodes, n_edges);
    b_eq = [-V; zeros(n_nodes-2, 1); V];

    % Construct flow conservation constraints for each node
    for i = 1:n_nodes
        outgoing_edges = G(i, G(i,:) > 0);  % Find outgoing edges
        incoming_edges = G(G(:,i) > 0, i)'; % Find incoming edges

        A_eq(i, incoming_edges) = 1;  % Inflow contribution
        A_eq(i, outgoing_edges) = -1; % Outflow contribution
    end
    
    % Define lower and upper bounds for optimization variables
    lb = zeros(size(C));  % Flow cannot be negative
    ub = C;               % Flow cannot exceed capacity limits

    % Solve the constrained optimization problem using fmincon
    [x, fval] = fmincon(objective, x0, [], [], A_eq, b_eq, lb, ub);
end
