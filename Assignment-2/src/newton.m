function d_k = newton(grad, hes)
    d_k = -grad / hes;
    d_k = d_k / norm(d_k);
end