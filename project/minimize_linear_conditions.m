function [x, fval] = minimize_linear_conditions(objective, G, C, V, x0)
    n_nodes = size(G, 1);
    n_edges = length(C);
    
    A_eq = zeros(n_nodes, n_edges);
    b_eq = [-V; zeros(n_nodes-2, 1); V];
    for i = 1:n_nodes
        outcoming_edges = G(i, G(i,:) > 0);
        incoming_edges = G(G(:,i) > 0, i)';
        A_eq(i, incoming_edges) = 1;
        A_eq(i, outcoming_edges) = -1;
    end
    
    lb = zeros(size(C));
    ub = C;
    [x, fval] = fmincon(objective, x0, [], [], A_eq, b_eq, lb, ub);
end
