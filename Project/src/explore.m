function x = explore(G, C, V, N, max_iters)
    % EXPLORE Generates an initial population of feasible solutions.
    %
    % This function randomly generates N feasible solutions for vehicle flow in a network,
    % ensuring that the generated flows respect both capacity constraints and flow conservation.
    %
    % INPUTS:
    %   - G         : Graph adjacency matrix (n_nodes x n_nodes).
    %   - C         : Vector of edge capacity constraints (n_edges x 1).
    %   - V         : Total incoming vehicle flow.
    %   - N         : Number of feasible solutions to generate.
    %   - max_iters : Maximum iterations allowed to find feasible solutions.
    %
    % OUTPUT:
    %   - x : Matrix (n_edges x N) containing N feasible solutions.

    % Get number of nodes and edges
    n_nodes = size(G, 1);
    n_edges = length(C);

    % Initialize the solution matrix
    x = zeros(n_edges, N);

    point_cnt = 1;  % Counter for generated solutions
    iter = 0;

    % Generate feasible solutions
    while point_cnt <= N && iter < max_iters

        iter = iter + 1;  % Increment iteration counter

        % Initialize inflow and remaining capacities
        inflow = zeros(1, n_nodes);
        inflow(1) = V;   % Set initial vehicle inflow at the first node
        C_remained = C;  % Remaining capacity for each edge
        success = true;  % Feasibility flag

        % Distribute flow across the network
        for i = 1:n_nodes-1
            neighbors = find(G(i,:) > 0);  % Identify current node's neighbors
            total_outflow_capacities = sum(C_remained(G(i, G(i,:) > 0)));

            % If inflow exceeds the total available outflow capacity, solution is infeasible
            if inflow(i) > total_outflow_capacities
                success = false;
                break;
            end

            % Distribute flow randomly among outgoing edges
            while inflow(i) > 0
                for neighbor = neighbors
                    % Determine flow allocation within available capacity
                    flow = rand * min(C_remained(G(i,neighbor)), inflow(i));
                    inflow(neighbor) = inflow(neighbor) + flow;  % Update inflow at the neighbor
                    C_remained(G(i,neighbor)) = C_remained(G(i,neighbor)) - flow;  % Reduce remaining capacity
                    inflow(i) = inflow(i) - flow;  % Reduce current node's outflow
                end
            end
        end

        % If a feasible solution is found, store it
        if success
            iter = 0;  % Reset iteration counter on success
            x(:,point_cnt) = C - C_remained;  % Store solution (used capacities)
            point_cnt = point_cnt + 1;  % Move to next solution
        end
    end

    % Error if no feasible solutions are found within maximum number of iterations
    if iter == max_iters
        error('Failed to generate feasible initial solutions (max_iters=%d)', max_iters);
    end
end