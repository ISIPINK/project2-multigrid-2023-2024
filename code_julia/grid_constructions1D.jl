using SparseArrays, LinearAlgebra

function Poisson1D(grid::AbstractArray)
    h = diff(grid)
    hm = @view h[1:end-1]
    hp = @view h[2:end]
    h_avg = (hm .+ hp) ./ 2

    diag_main = -(1 ./ hm + 1 ./ hp) ./ h_avg
    diag_upper = 1 ./ (hp.*h_avg)[1:end-1]
    diag_lower = 1 ./ (hm.*h_avg)[2:end]

    return spdiagm(-1 => diag_lower, 0 => diag_main, 1 => diag_upper)
end