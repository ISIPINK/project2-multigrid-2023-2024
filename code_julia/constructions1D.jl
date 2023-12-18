using SparseArrays, LinearAlgebra


function helmholtz1D(n, sigma)
    A = n^2 * spdiagm(-1 => -ones(n - 2),
        0 => 2 * ones(n - 1), 1 => -ones(n - 2))
    return A + sigma * I
end

function Poisson1D(grid::Array)
    h = diff(grid)
    hm = @view h[1:end-1]
    hp = @view h[2:end]
    h_avg = (hm .+ hp) ./ 2

    diag_main = -(1 ./ hm + 1 ./ hp) ./ h_avg
    diag_upper = 1 ./ (hp.*h_avg)[1:end-1]
    diag_lower = 1 ./ (hm.*h_avg)[2:end]

    return spdiagm(-1 => diag_lower, 0 => diag_main, 1 => diag_upper)
end

function eigen_helmhotz1D(n, k, sigma)
    return 4 * sin(k * π / (2 * n))^2 * n^2 + sigma
end

function Romega(n, sigma, omega)
    H = helmholtz1D(n, sigma)
    Dinv = spdiagm(0 => 1 ./ diag(H))
    return I - omega * Dinv * H
end

function simple_restrict_matrix(n)
    if n % 2 != 0
        error("restrict matrix needs n even")
    end
    R = spzeros(n ÷ 2 - 1, n - 1)
    row0 = [1, 2, 1] / 4
    # need to check indexing
    for i in 1:size(R, 1)
        R[i, 2*i-1:2*i+1] = row0
    end
    return R
end

function simple_interpolate_matrix(n, lin_boundary=false)
    P = spzeros(2 * n - 1, n - 1)
    col0 = [1, 2, 1] / 2
    for j in 1:size(P, 2)
        P[2*j-1:2*j+1, j] = col0
    end
    if lin_boundary
        P[1, 1] = 3 / 2
        P[1, 2] = -1 / 2
        P[end, end] = 3 / 2
        P[end, end-1] = -1 / 2
    end
    return P
end

function wave_basis_1D(n, k)
    return [sin(j * k * π / n) for j in 1:n-1]
end

function wave_basis_1D_complex(n, k)
    return [-im * exp(im * j * k * π / n) for j in 1:n-1]
end

function pointsource_half(n)
    return [ifelse(j == n ÷ 2, n, 0) for j in 1:n-1]
end

# maybe i need to shift j
function guessv0(n)
    return [0.5 * (sin(j * 16 * π / n) + sin(j * 40 * π / n)) for j in 1:n-1]
end