using Plots
include("constructions2D.jl")
include("grid_constructions2D.jl")

begin
    n = 2^7
    grid, m = linspacecs(0, 1, n + 1, pi / 6)

    R = restrict_matrix2D(grid[2:2:end])
    P = interpolate_matrix2D(grid)
    PP = interpolate_matrix2D(grid[2:2:end])
    w = wave_basis_2D(n, 1, 1)
    println(size(R))
    println(size(PP))

    # heatmap(reshape(w,2n-1,2n-1), color=:viridis, title="wave basis 2D")
    ee = PP * (R * w) - w

    # heatmap(reshape(real(ww),2n-1,2n-1), color=:viridis, title="wave basis 2D")
    heatmap(reshape(real(ee), n - 1, n - 1), color=:viridis, title="wave basis 2D")

end