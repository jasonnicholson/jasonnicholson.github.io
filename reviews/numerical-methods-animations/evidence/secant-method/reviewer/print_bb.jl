# secantmethodbb.jl
# Secant Method animation: Slow Convergence
# f(x) = 1 - 10x + 25x² = (1 - 5x)², double root at x = 0.2
# p0=1.0, p1=0.9, n=28
# Produces: secantmethodbb.gif




# --- Parameters ---
f(x) = 1 - 10*x + 25*x^2
p0   = 1.0
p1   = 0.9
n_iters = 28

xlims = (0.0, 1.0)
ylims = (0.0, 16.0)

title_str = "Secant Method: f(x) = 1 − 10x + 25x² (double root)"

# --- Pre-compute iterates ---
ps = Vector{Float64}(undef, n_iters + 2)
ps[1] = p0
ps[2] = p1
for i in 2:n_iters+1
    denom = f(ps[i]) - f(ps[i-1])
    if abs(denom) < 1e-14
        ps[i+1] = ps[i]
    else
        ps[i+1] = ps[i] - f(ps[i]) * (ps[i] - ps[i-1]) / denom
    end
end

using Printf
println("CASE ", PROGRAM_FILE)
for (j,p) in enumerate(ps)
    @printf("p%-2d = %.17g   f=%.6g\n", j-1, p, f(p))
end
