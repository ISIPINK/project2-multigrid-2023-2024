"""
    linspacecs(a, b, n, ecsangle)

Defines an ECS grid. Returns a linearly spaced grid with `n` points between points `a` and `b`, 
with two complex contours left of `a` and right of `b`. Each complex contour has `m` points.

# Arguments
- `a`: Start of the range
- `b`: End of the range
- `n`: Number of points in the range
- `ecsangle`: Angle for the complex contours

# Returns
- `z`: The generated grid
- `m`: Half of the number of points in the grid

# Author
Siegfried Cools, University of Antwerp, December 2023
"""
function linspacecs(a, b, n, ecsangle)
    m = floor(n / 2)
    zcenter = range(a, stop=b, length=n)
    h = zcenter[2] - zcenter[1]
    zright = h * (1:(m-1)) * (1 + 1im * tan(ecsangle))
    zleft = reverse(zright)
    z = [a - zleft; zcenter; b + zright]
    return z, m
end


let
    using Plots
    z, m = linspacecs(0, 10, 100, π / 4)
    p = plot(real(z), imag(z), title="ECS grid", label="grid points", seriestype=:scatter)
    display(p)
end