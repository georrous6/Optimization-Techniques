function res = grad_objfunc(x, y)
    dfdx = (5 * x.^4 - 2 * x.^6) .* exp(-x.^2 - y.^2);
    dfdy = -2 * y .* x.^5 .* exp(-x.^2 - y.^2);
    res = [dfdx, dfdy];
end
