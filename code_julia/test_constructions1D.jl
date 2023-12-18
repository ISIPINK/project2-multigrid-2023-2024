using Plots
include("constructions1D.jl")
include("grid_constructions1D.jl")


begin
    n = 10
    σ = 600
    ngrid = 4
    grid_points = vcat(range(-1, -1 / ngrid, length=2 * ngrid), range(0, 1, length=ngrid))
    H = helmholtz1D(n, σ)
    Rw = Romega(n, σ, 2 / 3)
    R = simple_restrict_matrix(n)
    P = simple_interpolate_matrix(n)
    Pgrid = interpolate_matrix(grid_points)
    pois1 = Poisson1D(grid_points)
    pois2 = Poisson1D([0, 1, 2, 4])
    mats = [H, Rw, R, P, Pgrid, pois1, pois2]
    titles = ["H", "Rw", "R", "P", "Pgrid", "pois1", "pois2"]

    for (mat, title) in zip(mats, titles)
        p = heatmap(mat, color=:viridis, title=title)
        display(p)
    end

end

begin
    n = 100
    f = pointsource_half(n)
    w = wave_basis_1D(n, 1)
    v0 = guessv0(n)
    titles = ["\$f, n = $n\$", "\$w, n = $n\$", "\$v_0,  n = $n\$"]

    for (vec, title) in zip([f, w, v0], titles)
        p = bar(vec, title=title)
        display(p)
    end
end

begin
    num_points = 10^1
    grid_points = vcat(range(-1, -1 / num_points, length=2 * num_points), range(0, 1, length=num_points))
    grid_points = grid_points[2:end-1]
    f(x) = sin((x + 1) * pi)
    d2f(x) = -pi^2 * sin((x + 1) * pi)
    function_values = f.(grid_points)
    second_derivative_values = d2f.(grid_points)
    plot(grid_points, zeros(size(grid_points)), label="grid_points", seriestype=:scatter, marker=:x)
    plot!(grid_points, function_values, label="function_values")
    plot!(grid_points, second_derivative_values, label="second_derivative_values")

    poisson_matrix = Poisson1D(grid_points)
    approx_second_derivative_values = poisson_matrix * function_values
    plot!(grid_points, approx_second_derivative_values, label="approx_second_derivative_values")
    # println(approx_second_derivative_values)
    # plot(diff(grid_points))
    # heatmap(poisson_matrix, color=:viridis, title="poisson_matrix")
end

begin
    num_points = 1 * 10^1
    fine_grid = vcat(range(-1, -0.5 - 1 / num_points, length=3 * num_points), range(-0.5, 1, length=num_points - 1))
    fine_grid = fine_grid[2:end-1]
    coarse_grid = fine_grid[2:2:end]
    f(x) = sin((x + 1) * pi)

    function_values = f.(fine_grid)
    coarse_f = f.(coarse_grid)
    P = interpolate_matrix(fine_grid)
    R = restrict_matrix(fine_grid)
    println(size(P))
    println(size(coarse_f))
    inter_f = P * coarse_f
    restrict_f = R * function_values
    println(size(inter_f))
    plot(fine_grid, function_values, label="fine", color=:blue, linestyle=:solid, marker=:circle)
    plot!(coarse_grid, coarse_f, label="coarse", color=:red, linestyle=:dash, marker=:square)
    plot!(coarse_grid, restrict_f, label="restrict", color=:green, linestyle=:dot, marker=:diamond)
    plot!(fine_grid, inter_f, label="interpolate", color=:purple, linestyle=:dashdot, marker=:cross)

end


