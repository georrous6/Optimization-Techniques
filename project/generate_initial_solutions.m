function x = generate_initial_solutions(G, C, V, N)
    % Generates random initial solutions that satisfy the restrictions of
    % the problem.
    %
    % G: The directed graph. G(i, j) == k, k > 0 means the kth edge goes 
    %    from node i to j.
    % C: The edges capacities
    % V: The rate of incoming vehicles
    % N: The number of initial solutions

    n_nodes = size(G, 1);
    n_edges = length(C);
    x = zeros(n_edges, N);

    point_cnt = 1;
    while point_cnt <= N

        inflow = zeros(1, n_nodes);
        inflow(1) = V;
        C_remained = C;
        success = true;

        for i = 1:n_nodes-1
            neighbors = find(G(i,:) > 0);
            total_outflow_capacities = sum(C_remained(G(i, G(i,:) > 0)));

            if inflow(i) > total_outflow_capacities
                success = false;
                break;
            end

            while inflow(i) > 0
                for neighbor = neighbors
                    flow = rand * min(C_remained(G(i,neighbor)), inflow(i));
                    inflow(neighbor) = inflow(neighbor) + flow;
                    C_remained(G(i,neighbor)) = C_remained(G(i,neighbor)) - flow;
                    inflow(i) = inflow(i) - flow;
                end
            end
        end

        if success
            x(:,point_cnt) = C - C_remained;
            point_cnt = point_cnt + 1;
        end
    end

end