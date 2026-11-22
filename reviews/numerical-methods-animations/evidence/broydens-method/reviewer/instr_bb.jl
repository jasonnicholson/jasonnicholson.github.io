# broydenbb.jl
# Broyden's Method animation: convergence to solution 2 near (2.808, -1.665)
# System: f1(x,y) = 1 - 4x + 2x² - 2y² = 0
#         f2(x,y) = -4 + x² + 4y + y² = 0
# Starting point: (2.5, -1.5)
# Produces: broydenbb.gif


using LinearAlgebra


# --- System ---
F(x, y) = [1 - 4x + 2x^2 - 2y^2,
           -4 + x^2 + 4y + y^2]

# Exact Jacobian (used only at step 0)
function Jac(x, y)
    [-4 + 4x   -4y
      2x        4 + 2y]
end

# --- Parameters ---
x0, y0 = 2.5, -1.5
n_iters = 10

xlims = (-1.0, 3.5)
ylims = (-2.5, 2.0)

title_str = "Broyden's Method: solution near (2.808, -1.665)"

# --- Run Broyden's method ---
function run_broyden(x0, y0, n_iters)
    iterates = Vector{Vector{Float64}}()
    push!(iterates, [x0, y0])

    X_prev = [x0, y0]
    F_prev = F(x0, y0)

    # Step 0: one exact Newton step
    B = Jac(x0, y0)
    X_curr = X_prev - B \ F_prev
    push!(iterates, copy(X_curr))

    # Steps 1..n_iters: quasi-Newton (Broyden) updates
    for k in 1:n_iters
        F_curr = F(X_curr[1], X_curr[2])
        if norm(F_curr) < 1e-12
            break
        end
        s = X_curr - X_prev
        y_vec = F_curr - F_prev
        denom = dot(s, s)
        if denom < 1e-20
            break
        end
        B = B + (y_vec - B * s) * s' / denom   # rank-1 update
        X_next = X_curr - B \ F_curr
        X_prev = X_curr
        F_prev = F_curr
        X_curr = X_next
        push!(iterates, copy(X_curr))
    end
    return iterates
end

iterates = run_broyden(x0, y0, n_iters)
using Printf
println("n_iterates = ", length(iterates), "  n_frames = ", length(iterates))
for (k,p) in enumerate(iterates)
    Fv = F(p[1],p[2])
    @printf("k=%2d x=% .17g y=% .17g |F|=%.3e  label=(%s, %s)\n", k-1, p[1], p[2], norm(Fv), string(round(p[1];digits=4)), string(round(p[2];digits=4)))
end
