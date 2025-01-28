function offspring = mutation(parents, N, G, C, V, sigma, tol, max_iters)
    if size(sigma, 2) ~= 1
        error('<sigma> must be a column vector');
    end
    if length(sigma) ~= size(parents, 1)
        error('The number of rows of matrix <parents> must be equal to the number of elements of the vector <sigma>');
    end
    
    n_points = size(parents, 2);
    offspring = parents;
    i = 1;
    idx = randperm(n_points, N);

    iter = 0;
    while i <= N && iter < max_iters
        iter = iter + 1;
        off = offspring(:,idx(i)) + randn * sigma;
        if is_feasible(G, C, V, off, tol)
            offspring(:,idx(i)) = off;
            iter = 0;
            i = i + 1;
        end
    end

    if iter == max_iters
        warning('Failed to generate a feasible solution after mutation (max_iters=%d)', max_iters);
    end
end