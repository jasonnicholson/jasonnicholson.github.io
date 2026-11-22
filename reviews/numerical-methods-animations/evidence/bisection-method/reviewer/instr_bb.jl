# bisectionbb.jl
# Bisection Method animation: f(x) = tan(x), interval [1, 2]
# Cautionary case: sign change on [1,2] is due to the asymptote at π/2 ≈ 1.5708,
# not a true root. Bisection converges to the discontinuity.
# Produces: bisectionbb.gif




# --- Parameters ---
f(x) = tan(x)
a0, b0 = 1.0, 2.0
n_iters = 12

xlims = (0.0, 2.2)
ylims = (-15.0, 15.0)

title_str = "Bisection Method: f(x) = tan(x)  [cautionary case]"

# --- Pre-compute bisection steps ---
as = Vector{Float64}(undef, n_iters + 1)
bs = Vector{Float64}(undef, n_iters + 1)
cs = Vector{Float64}(undef, n_iters)
as[1] = a0
bs[1] = b0
for i in 1:n_iters
    c = (as[i] + bs[i]) / 2
    cs[i] = c
    if f(as[i]) * f(c) < 0
        as[i+1] = as[i]
        bs[i+1] = c
    else
        as[i+1] = c
        bs[i+1] = bs[i]
    end
end

using Printf
for i in 1:n_iters
    @printf("%2d a=%.12f b=%.12f c=%.12f f(c)=% .6e  legend=%s  newbracket=[%.10f, %.10f]\n", i, as[i], bs[i], cs[i], f(cs[i]), string(round(cs[i]; digits=6)), as[i+1], bs[i+1])
end
@printf("final bracket width %.3e\n", bs[end]-as[end])
