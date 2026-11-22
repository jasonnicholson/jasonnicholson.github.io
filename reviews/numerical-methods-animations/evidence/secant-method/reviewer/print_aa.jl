# secantmethodaa.jl
# Secant Method animation: Fast Convergence
# f(x) = 3*exp(x) - 4*cos(x), p0=1.0, p1=0.9, n=9
# Produces: secantmethodaa.gif




# --- Parameters ---
f(x) = 3*exp(x) - 4*cos(x)
p0   = 1.0
p1   = 0.9
n_iters = 9

xlims = (0.0, 1.0)
ylims = (-1.0, 6.0)

title_str = "Secant Method: f(x) = 3eˣ − 4cos(x)"

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
