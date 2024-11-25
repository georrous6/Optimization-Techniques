function d_k = levenberg_marquardt(grad, hes)
    u_k = 0;
    eigenvalues = eig(hes);
    if ~all(eigenvalues > 0)
        u_k = 1.001 * max(abs(eigenvalues));
    end
    d_k = -grad / (hes + u_k * eye(2));
    d_k = d_k / norm(d_k);
end