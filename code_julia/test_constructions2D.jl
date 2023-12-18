using Plots
include("constructions2D.jl")
include("grid_constuctions2D.jl")


begin
    n = 10
    σ = 600
    ngrid = 4
    grid_points = vcat(range(-1, -1 / ngrid, length=2 * ngrid), range(0, 1, length=ngrid))
    H = helmholtz2D(n, σ)
    sigmas = σ * ones((length(grid_points) - 2)^2)
    Hgrid = helmholtz2D(grid_points, sigmas)
    R = simple_restrict_matrix2D(n)
    P = simple_interpolate_matrix2D(n)
    mats = [H, Hgrid, R, P]
    titles = ["H", "Hgrid", "R", "P"]

    for (mat, title) in zip(mats, titles)
        p = heatmap(mat, color=:viridis, title=title)
        display(p)
    end
    x_coords = repeat(grid_points, length(grid_points))
    y_coords = reshape(repeat(grid_points', length(grid_points)), :, 1)
    scatter(x_coords, y_coords, label="2D grid", seriestype=:scatter, marker=:x)

end

begin
    n = 10
    k = 1
    l = 1
    wave_2D = reshape(wave_basis_2D(n, k, l), n - 1, n - 1)
    heatmap(wave_2D, color=:viridis, title="wave basis 2D")
end

begin
    n = 64
    k = 9
    wave_2D = reshape(wave_basis_2Dx(n, k), n - 1, n - 1)
    heatmap(wave_2D, color=:viridis, title="wave basisx 2D")
end

begin
    n = 64
    p = plot()  # Initialize an empty plot
    @gif for k in 1:n-1
        wave_2D = reshape(wave_basis_2Dy(n, k), n - 1, n - 1)
        heatmap!(p, wave_2D, color=:viridis, title="wave basisy 2D, k = $k")
    end fps = 1
end

begin
    n = 10
    k = 1
    l = 1
    wave_2D = reshape(wave_basis_2D_complex(n, k, l), n - 1, n - 1)
    p1 = heatmap(real(wave_2D), color=:viridis, title="Re w com")
    p2 = heatmap(imag(wave_2D), color=:viridis, title="Im w com")
    plot(p1, p2, layout=(1, 2))
end

begin
    n = 64
    ps = reshape(pointsource_half2D(n), n - 1, n - 1)
    plot(heatmap(ps, color=:viridis, title="Re w com"))
end