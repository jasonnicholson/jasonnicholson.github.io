# accnewtonaa.jl
# Accelerated & Modified Newton-Raphson animation: Standard Newton at double root
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.2
# Shows LINEAR (slow) convergence — standard Newton degrades at multiple roots.
# Produces: accnewtonaa.gif




# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.2
n_iters = 12

xlims = (0.7, 1.8)
ylims = (-0.05, 1.0)

title_str = "Standard Newton: f(x) = x³−3x+2 (double root at x=1)"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])
end

using Printf
println("script: ", @__FILE__)
for (k,x) in enumerate(xs)
    lbl = round(x; digits=6)
    @printf("n=%2d x=%.17g  e=%.6e  label=%s\n", k-1, x, x-1, string(lbl))
end
