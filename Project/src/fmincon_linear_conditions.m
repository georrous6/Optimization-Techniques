function [x, fval] = fmincon_linear_conditions(objective, G, V, lb, ub, x0)
    % FMINCON_LINEAR_CONDITIONS Optimizes vehicle flow in a network using fmincon.
    %
    % This function finds an optimal vehicle flow distribution that minimizes the 
    % given objective function while satisfying flow conservation constraints and 
    % adhering to capacity bounds.
    %
    % INPUTS:
    %   - objective : Function handle representing the objective function.
    %   - G         : Adjacency matrix representing the network (n_nodes x n_nodes).
    %   - V         : Total incoming vehicle flow into the network.
    %   - lb        : Lower bounds for optimization variables.
    %   - ub        : Upper bounds for optimization variables.
    %   - x0        : Initial guess for the optimization variables (n_features x 1).
    %
    % OUTPUTS:
    %   - x         : Optimized flow distribution across the network edges.
    %   - fval      : Final value of the objective function at the optimal solution.
    %
    % Extract the number of nodes and optimization variables
    n_nodes = size(G, 1);      % Number of nodes in the network
    n_features = size(x0, 1);  % Number of optimization variables
    
    % Initialize the linear equality constraint matrix (flow conservation)
    A_eq = zeros(n_nodes, n_features);
    b_eq = [-V; zeros(n_nodes-2, 1); V]; % Net inflow and outflow constraints
    
    % Construct flow conservation constraints for each node
    for i = 1:n_nodes
        % Identify outgoing and incoming edges for node i
        outgoing_edges = G(i, G(i,:) > 0);  % Edges leaving the node
        incoming_edges = G(G(:,i) > 0, i)'; % Edges entering the node
        
        % Define flow conservation equation
        A_eq(i, incoming_edges) = 1;  % Vehicles entering the node
        A_eq(i, outgoing_edges) = -1; % Vehicles leaving the node
    end
    
    % Solve the constrained optimization problem using fmincon
    [x, fval] = fmincon(objective, x0, [], [], A_eq, b_eq, lb, ub);
end
