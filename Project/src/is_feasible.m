function result = is_feasible(G, V, lb, ub, x, tol)
    % IS_FEASIBLE Checks if a given solution satisfies flow and capacity constraints.
    %
    % This function verifies whether a given candidate solution satisfies 
    % both flow conservation constraints and edge capacity constraints.
    %
    % INPUTS:
    %   - G   : Graph adjacency matrix (n_nodes x n_nodes)
    %   - V   : Total incoming vehicle flow (scalar).
    %           If V > 0, all solutions share the same total inflow.
    %           If V <= 0, each solution defines its own total inflow (last feature in x).
    %   - lb  : Lower bounds for optimization variables (n_features x 1).
    %   - ub  : Upper bounds for optimization variables (n_features x 1).
    %   - x   : Matrix of candidate solutions (n_features x n_points)
    %   - tol : Tolerance for numerical feasibility check
    %
    % OUTPUT:
    %   - result : Boolean array (1 x n_points) indicating feasibility of each solution
    %
    % A solution is feasible if:
    %   1. It satisfies the flow conservation constraints: A_eq * x = b_eq
    %   2. All flow values are within the capacity bounds: 0 <= x_i <= C_i

    % Get the number of candidate solutions and nodes
    [n_features, n_points] = size(x);    % Number of features and candidate solutions
    n_nodes = size(G, 1);                % Number of nodes

    % Initialize the feasibility result array (false by default)
    result = false(1, n_points);

    % Construct the linear equality constraints matrices (A_eq * x = b_eq)
    A_eq = zeros(n_nodes, n_features);
    for i = 1:n_nodes
        % Identify outgoing and incoming edges for node i
        outgoing_edges = G(i, G(i,:) > 0);
        incoming_edges = G(G(:,i) > 0, i)';

        % Set up flow conservation equation
        A_eq(i, incoming_edges) = 1;  % Vehicles entering the node
        A_eq(i, outgoing_edges) = -1; % Vehicles leaving the node
    end

    % Check if each point satisfies the constraints
    if V > 0  
        % Case 1: All solutions share the same total inflow (V is fixed)
        b_eq = [-V; zeros(n_nodes-2, 1); V];  % Net inflow and outflow at each node
        for i = 1:n_points
            if (sum(abs(A_eq * x(:,i) - b_eq) < tol) == n_nodes) && (sum(x(:,i) >= lb & x(:,i) < ub) == n_features)
                result(i) = true;
            end
        end
    else
        % Case 2: Each solution has its own total inflow (last row of x)
        for i = 1:n_points
            b_eq = [-x(end,i); zeros(n_nodes-2, 1); x(end,i)];  % Net inflow and outflow at each node
            if (sum(abs(A_eq * x(:,i) - b_eq) < tol) == n_nodes) && (sum(x(:,i) >= lb & x(:,i) < ub) == n_features)
                result(i) = true;
            end
        end
    end
end