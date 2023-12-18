using SparseArrays, LinearAlgebra
include("grid_constructions2D.jl")

function wjacobi_short(A, f, u, omega)
    Dinv = spdiagm(0 => 1 ./ diag(A))
    U, L = triu(A, 1), tril(A, -1)
    return (1 - omega) * u + omega * Dinv * (f - (U + L) * u)
end

function wjacobi(A, f, u, omega)
    Dinv = spdiagm(0 => 1 ./ diag(A))
    U, L = triu(A, 1), tril(A, -1)
    temp = U * u
    temp .+= L * u
    temp .= f .- temp
    temp .= Dinv * temp
    temp .= (1 - omega) .* u .+ omega .* temp
    return temp
end

function nonUniformVcycle2D(; grid, A, f, u, nu1, nu2, recursion_depth)

    if n <= 3 || recursion_depth == 0
        return A \ f
    end

    for _ in 1:nu1
        u = wjacobi(A, f, u, 2 / 3)
    end
    R = restrict_matrix2D(grid)
    P = interpolate_matrix2D(grid)

    r_coarse = R * (f - A * u)
    e_coarse = nonUniformVcycle2D(
        grid=grid[2:2:end],
        A=P * A * R, #galerkin property
        f=r_coarse,
        u=zero(r_coarse),
        nu1=nu1,
        nu2=nu2,
        recursion_depth=recursion_depth - 1)

    e = P * e_coarse
    u += e

    for _ in 1:nu2
        u = wjacobi(A, f, u, 2 / 3)
    end
    return u
end

