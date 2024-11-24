function res = objfunc_hessian(x, y)
    fxx = (20 * x.^3 - 22 * x.^5 + 4 * x.^7) .* exp(- x^2 - y^2);
    fxy = (4 * x.^6 .* y - 10 * x.^4 .* y) .* exp(- x.^2 - y.^2);
    fyy = (4 * x.^5 .* y.^2 - 2 * x.^5) .* exp(- x.^2 - y.^2);
    res = [fxx, fxy; fxy, fyy];
end