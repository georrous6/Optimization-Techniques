function [d_k, isPositiveDefinite] = newton(grad, hes)
    isPositiveDefinite = true;
    eigenvalues = eig(hes);
    
    if ~all(eigenvalues > 0)  % Non positive definite hessian matrix
        isPositiveDefinite = false;
    end

    d_k = -grad / hes;
    d_k = d_k / norm(d_k);
end