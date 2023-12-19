using Plots, SparseArrays, LinearAlgebra, IterativeSolvers, Revise
include("nonuniformMultiGrid.jl")

struct myPreconditioner
    precon::Function
end

function LinearAlgebra.ldiv!(y, P::myPreconditioner, x)
    y .= P.precon(x)
    return y
end

function LinearAlgebra.ldiv!(P::myPreconditioner, x)
    x .= P.precon(x)
    return x
end

function LinearAlgebra.:\(P::myPreconditioner, x)
    return P.pre_con(x)
end

function nonuniform_preconditioner(; grid, H, f, nu1, nu2)
    pres(x) = nonUniformVcycle2D(
        grid=grid,
        A=H,
        f=f,
        u=x,
        nu1=nu1,
        nu2=nu2,
        recursion_depth=50)
    return myPreconditioner(pres)
end