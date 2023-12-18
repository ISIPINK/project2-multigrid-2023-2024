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
    k = length(grid) - 2
    A_2D = kron(sparse(I, k, k), A_1D) .+ kron(A_1D, sparse(I, k, k))
    return A_2D .+ σ
end