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
# Check: drawn line (through (pa,fa) with slope (fb-fa)/(pb-pa)) passes through (pb,fb) and its x-intercept is the next iterate
maxres=0.0; maxint=0.0
for frame in 1:n_iters
    pa=ps[frame]; pb=ps[frame+1]; fa=f(pa); fb=f(pb)
    abs(fb-fa) > 1e-14 || continue
    s=(fb-fa)/(pb-pa)
    global maxres=max(maxres, abs(fa + s*(pb-pa) - fb)/max(1,abs(fb)))
    global maxint=max(maxint, abs((pa - fa/s) - ps[frame+2])/max(1e-300,abs(ps[frame+2])+abs(pb-pa)))
end
println(PROGRAM_FILE, "  max rel residual at pb: ", maxres, "   max rel |x-intercept - next iterate|: ", maxint)
