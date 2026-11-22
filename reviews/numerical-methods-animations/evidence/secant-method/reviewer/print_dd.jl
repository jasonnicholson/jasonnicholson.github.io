# secantmethoddd.jl
# Secant Method animation: Convergence (oscillating path to real root)
# f(x) = x³ - x + 3, p0=2.0, p1=1.0, n=16
# Real root near x ≈ -1.6724
# Produces: secantmethoddd.gif




# --- Parameters ---
f(x) = x^3 - x + 3
p0   = 2.0
p1   = 1.0
n_iters = 16

xlims = (-3.2, 3.5)
ylims = (-5.0, 32.0)

title_str = "Secant Method: f(x) = x³ − x + 3"

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
    # Stop if converged
    if abs(ps[i+1] - ps[i]) < 1e-8 && i > 4
        n_iters_actual = i
        break
    end
end

using Printf
println("CASE ", PROGRAM_FILE)
for (j,p) in enumerate(ps)
    @printf("p%-2d = %.17g   f=%.6g\n", j-1, p, f(p))
end
