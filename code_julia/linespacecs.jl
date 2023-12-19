using Plots
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
    z = [a .- zleft; zcenter; b .+ zright]
    return z, m
end

function test_linespacecs()
    z, m = linspacecs(0, 1, 17, π / 6)
    zz = z[2:2:end]
    p = plot(real(z), imag(z), title="ECS grid", label="grid points", seriestype=:scatter, marker=:x)
    plot!(p, real(zz), imag(zz) .+ 0.1, label="grid points half", seriestype=:scatter, marker=:x)
    plot!(p, real(z), imag(z), label="line", linewidth=1, color=:blue)

    # Mark -0.5 and 1.5 on the plot
    scatter!([-0.5, 1.5], [0, 0], color=:red, marker=:circle, label="marked points")

    display(p)
end

function test_linespacecs_even()
    z, m = linspacecs(0, 1, 17, π / 6)
    z = z[2:2:end]
    p = plot(real(z), imag(z), title="ECS grid", label="grid points", seriestype=:scatter, marker=:x)
    plot!(real(z), imag(z), label="line", linewidth=1, color=:blue)

    # Mark -0.5 and 1.5 on the plot
    scatter!([-0.5, 1.5], [0, 0], color=:red, marker=:circle, label="marked points")

    display(p)
end