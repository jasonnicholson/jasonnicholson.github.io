# secantmethodff.jl
# Secant Method animation: Convergence
# f(x) = arctan(x), p0=1.60, p1=1.50, n=6
# Root at x=0; method converges directly
# Produces: secantmethodff.gif




# --- Parameters ---
f(x) = atan(x)
p0   = 1.60
p1   = 1.50
n_iters = 6

xlims = (-3.0, 2.0)
ylims = (-1.25, 1.15)

title_str = "Secant Method: f(x) = arctan(x)"

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
