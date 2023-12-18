using SparseArrays, LinearAlgebra
include("grid_constructions1D.jl")


"""
    helmholtz2D(grid::Array, σ::Array)

Construct a 2D Helmholtz operator using a given grid and wavenumbers.

# Arguments
- `grid::Array`: An array of grid points.
- `σ::Array`: An array of wavenumbers for the diagonal.

# Returns
- A 2D Helmholtz matrix.
"""
function helmholtz2D(grid::AbstractArray, σ::AbstractArray)
    A_1D = Poisson1D(grid)
    n = length(grid) + 1
    A_2D = kron(sparse(I, n - 1, n - 1), A_1D) .+ kron(A_1D, sparse(I, n - 1, n - 1))
    return A_2D .+ σ
end


function restrict_matrix2D(finegrid::AbstractArray)
    R_1D = restrict_matrix(finegrid)
    return kron(R_1D, R_1D)
end

function interpolate_matrix2D(finegrid::AbstractArray)
    P_1D = interpolate_matrix(finegrid)
    return kron(P_1D, P_1D)
end

