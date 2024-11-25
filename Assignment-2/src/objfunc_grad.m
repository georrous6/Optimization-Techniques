function res = objfunc_grad(x, y)
    fx = (5 * x.^4 - 2 * x.^6) .* exp(-x.^2 - y.^2);
    fy = -2 * y .* x.^5 .* exp(-x.^2 - y.^2);
    res = [fx, fy];
end
