using Plots

include("constructions1D.jl")



begin
    n = 10
    σ = 600
    H = helmholtz1D(n, σ)
    Rw = Romega(n, σ, 2 / 3)
    R = simple_restrict_matrix(n)
    P = simple_interpolate_matrix(n)
    pois1 = Poisson1D(range(-1, 1, length=n))
    pois2 = Poisson1D([0, 1, 2, 4])
    mats = [H, Rw, R, P, pois1, pois2]
    titles = ["H", "Rw", "R", "P", "pois1", "pois2"]

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
    f(x) = sin((x + 1) * pi)
    d2f(x) = -pi^2 * sin((x + 1) * pi)
    function_values = f.(grid_points)
    second_derivative_values = d2f.(grid_points)
    plot(grid_points, zeros(size(grid_points)), label="grid_points", seriestype=:scatter, marker=:x)
    plot!(grid_points, function_values, label="function_values")
    plot!(grid_points, second_derivative_values, label="second_derivative_values")

    poisson_matrix = Poisson1D(grid_points)
    approx_second_derivative_values = poisson_matrix * function_values[2:end-1]
    plot!(grid_points[2:end-1], approx_second_derivative_values, label="approx_second_derivative_values")
    # println(approx_second_derivative_values)
    # plot(diff(grid_points))
    # heatmap(poisson_matrix, color=:viridis, title="poisson_matrix")
end
