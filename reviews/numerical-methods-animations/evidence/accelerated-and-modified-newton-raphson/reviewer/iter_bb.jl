# accnewtonbb.jl
# Accelerated & Modified Newton-Raphson animation: Accelerated Newton (Method A, m=2)
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.2
# Formula: x_{n+1} = x_n - m * f(x_n)/f'(x_n), m=2
# Shows QUADRATIC (fast) convergence restored by multiplying Newton step by m.
# Produces: accnewtonbb.gif




# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.2
n_iters = 5
m       = 2   # known multiplicity of the double root

xlims = (0.7, 1.8)
ylims = (-0.05, 1.0)

title_str = "Accelerated Newton (m=2): f(x) = x³−3x+2"

# --- Pre-compute iterates using Method A ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - m * f(xs[i]) / fp(xs[i])
end

using Printf
println("script: ", @__FILE__)
for (k,x) in enumerate(xs)
    lbl = round(x; digits=6)
    @printf("n=%2d x=%.17g  e=%.6e  label=%s\n", k-1, x, x-1, string(lbl))
end
