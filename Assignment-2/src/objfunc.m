function z = objfunc(x, y)
    z = x.^5 .* exp(-x.^2 - y.^2); % Element-wise operations
end