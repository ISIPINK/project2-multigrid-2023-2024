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

function interpolate_matrix(finegrid::AbstractArray)
    n = (length(finegrid) + 1) ÷ 2
    P = spzeros(2 * n - 1, n - 1)
    h = diff(finegrid)

    for j in 1:n-1
        hm = h[j]
        hp = h[j+1]
        h_avg = hm + hp

        P[2*j-1, j] = hm / h_avg
        P[2*j, j] = 1
        P[2*j+1, j] = hp / h_avg
    end

    return P
end

function restrict_matrix(finegrid::AbstractArray)
    P = interpolate_matrix(finegrid)
    R = transpose(P)
    return 0.5 * R
end