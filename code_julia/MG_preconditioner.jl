using Plots, SparseArrays, LinearAlgebra, Revise
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
    return P.precon(x)
end

function LinearAlgebra.:mul!(y, P::myPreconditioner, x)
    y .= P.precon(x)
    return y
end

function nonuniform_preconditioner(; grid, H, nu1, nu2)
    pres(x) = nonUniformVcycle2D(
        grid=grid,
        A=H,
        f=x,
        u=zero(x),
        nu1=nu1,
        nu2=nu2,
        recursion_depth=50)
    return myPreconditioner(pres)
end

function gmres_callbackX!(X, solver)
    z = solver.z
    k = solver.inner_iter
    nr = sum(1:k)
    V = solver.V
    R = solver.R
    y = copy(z)

    # Solve Rk * yk = zk
    for i = k:-1:1
        pos = nr + i - k
        for j = k:-1:i+1
            y[i] = y[i] - R[pos] * y[j]
            pos = pos - j + 1
        end
        y[i] = y[i] / R[pos]
    end

    # xk = Vk * yk
    xk = sum(V[i] * y[i] for i = 1:k)
    push!(X, xk)

    return false  # We don't want to add new stopping conditions
end