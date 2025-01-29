function penalty = penalty_function(x, G, C, V)
    n_nodes = size(G, 1);
    
    % Capacity violation penalty
    penalty_capacity = sum(max(0, x - C).^2);
    
    % Flow conservation penalty
    flow = [V, zeros(1, n_nodes - 2), -V];

    for i = 1:n_nodes
        outgoing_edges = G(i, G(i,:) > 0);
        incoming_edges = G(G(:,i) > 0, i)';

        flow(i) = flow(i) + sum(x(incoming_edges)) - sum(x(outgoing_edges));
    end

    penalty_flow = sum(abs(flow));
    
    % Total penalty
    penalty = penalty_capacity + penalty_flow;
end
