# secantmethodee.jl
# Secant Method animation: NON Convergence — Diverging to Infinity
# f(x) = x * exp(-x), p0=1.5, p1=2.0, n=16
# Root at x=0; method diverges with these starting points
# Produces: secantmethodee.gif




# --- Parameters ---
f(x) = x * exp(-x)
p0   = 1.5
p1   = 2.0
n_iters = 16

xlims = (0.0, 10.1)
ylims = (0.0, 0.4)

title_str = "Secant Method: f(x) = x e⁻ˣ  (diverges)"

# --- Pre-compute iterates ---
ps = Vector{Float64}(undef, n_iters + 2)
ps[1] = p0
ps[2] = p1
n_valid = 1  # index of last valid (non-diverged) iterate
for i in 2:n_iters+1
    denom = f(ps[i]) - f(ps[i-1])
    if abs(denom) < 1e-14
        # Denominator ~0: method breaks down
        for j in (i+1):(n_iters+2)
            ps[j] = ps[i]
        end
        n_valid = i
        break
    end
    ps[i+1] = ps[i] - f(ps[i]) * (ps[i] - ps[i-1]) / denom
    n_valid = i + 1
    if abs(ps[i+1]) > 1e6 || isnan(ps[i+1]) || isinf(ps[i+1])
        # Diverged; fill remaining with large value
        for j in (i+2):(n_iters+2)
            ps[j] = ps[i+1]
        end
        break
    end
end

using Printf
println("CASE ", PROGRAM_FILE)
for (j,p) in enumerate(ps)
    @printf("p%-2d = %.17g   f=%.6g\n", j-1, p, f(p))
end
