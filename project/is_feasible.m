function result = is_feasible(G, C, V, x, tol)

    if length(C) ~= size(x, 1)
        error('The number of rows of matrix <x> must be equal to the number of elements of the vector <C>');
    end
    
    n_points = size(x, 2);
    n_edges = length(C);
    n_nodes = size(G, 1);
    result = false(1, n_points);

    % Construct the linear equality constraints matrices (A_eq * x = b_eq)
    A_eq = zeros(n_nodes, n_edges);
    b_eq = [-V; zeros(n_nodes-2, 1); V];
    for i = 1:n_nodes
        outcoming_edges = G(i, G(i,:) > 0);
        incoming_edges = G(G(:,i) > 0, i)';
        A_eq(i, incoming_edges) = 1;
        A_eq(i, outcoming_edges) = -1;
    end

    % Check if each point satisfies the constraints
    for i = 1:n_points
        if (sum(abs(A_eq * x(:,i) - b_eq) < tol) == n_nodes) && (sum(x(:,i) >= 0 & x(:,i) < C) == n_edges)
            result(i) = true;
        end
    end
end