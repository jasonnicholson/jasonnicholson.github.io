# accnewtoncc.jl
# Accelerated & Modified Newton-Raphson animation: Modified Newton (Method B)
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.2
# Method B: define h(x) = f(x)/f'(x); h has a SIMPLE root where f has a double root.
# Newton on h(x) gives: x_{n+1} = x_n - f(x_n)*f'(x_n) / (f'(x_n)^2 - f(x_n)*f''(x_n))
# Shows QUADRATIC (fast) convergence without needing to know the multiplicity m.
# The animation plots h(x) and shows Newton tangent lines converging in ~2 steps.
# Produces: accnewtoncc.gif




# --- Functions ---
f(x)   = x^3 - 3x + 2
fp(x)  = 3x^2 - 3
fpp(x) = 6x

# h(x) = f(x)/f'(x) = (x-1)*(x+2)/(3*(x+1))  [simplified form, valid for x ≠ ±1]
h_plot(x) = (x - 1) * (x + 2) / (3 * (x + 1))

# Modified Newton step (= Newton's step applied to h(x))
function modified_newton_step(x)
    fx   = f(x)
    fpx  = fp(x)
    fppx = fpp(x)
    denom = fpx^2 - fx * fppx
    x - fx * fpx / denom
end

# --- Parameters ---
x0      = 1.2
n_iters = 4

xlims = (0.5, 2.0)
ylims = (-0.4, 0.6)

title_str = "Modified Newton (Method B): h(x) = f(x)/f'(x)"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = modified_newton_step(xs[i])
end

using Printf
println("script: ", @__FILE__)
for (k,x) in enumerate(xs)
    lbl = round(x; digits=6)
    @printf("n=%2d x=%.17g  e=%.6e  label=%s\n", k-1, x, x-1, string(lbl))
end
