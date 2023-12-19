using Plots
include("constructions2D.jl")
include("grid_constructions2D.jl")
include("linespacecs.jl")

begin
    n = 2^4
    grid, m = linspacecs(0, 1, n + 1, pi / 6)
    grid = real(grid)
    num_points = 20
    fine_grid = vcat(range(-1, -0.5 - 1 / num_points, length=3 * num_points), range(-0.5, 1, length=num_points - 1))
    grid = fine_grid[2:end-1]
    R = restrict_matrix2D(grid[2:2:end])
    P = interpolate_matrix2D(grid)
    PP = interpolate_matrix2D(grid[2:2:end])

    display(heatmap(real(R), color=:viridis, title="reR"))
    display(heatmap(imag(R), color=:viridis, title="imR"))
    display(heatmap(real(PP), color=:viridis, title="rePP"))
    display(heatmap(imag(PP), color=:viridis, title="imPP"))

    w = wave_basis_2D((length(grid) - 1) / 2, 1, 1) + im * wave_basis_2D((length(grid) - 1) / 2, 1, 1)
    println(size(R))
    println(size(PP))
    println(size(w))

    # heatmap(reshape(w,2n-1,2n-1), color=:viridis, title="wave basis 2D")
    ee = PP * (R * w) - w

    # heatmap(reshape(real(ww),2n-1,2n-1), color=:viridis, title="wave basis 2D")
    k = Int((length(grid) - 1) / 2 - 1)
    heatmap(reshape(abs.(ee), k, k), color=:viridis, title="recon error")

end