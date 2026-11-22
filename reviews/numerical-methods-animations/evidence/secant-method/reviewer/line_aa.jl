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
