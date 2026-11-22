# bisectionaa.jl
# Bisection Method animation: f(x) = x^3 + 4x^2 - 10, interval [1, 2]
# True root ≈ 1.3688. Each frame advances one bisection step.
# Produces: bisectionaa.gif




# --- Parameters ---
f(x) = x^3 + 4x^2 - 10
a0, b0 = 1.0, 2.0
n_iters = 12

xlims = (-1.0, 2.2)
ylims = (-12.0, 16.0)

title_str = "Bisection Method: f(x) = x³ + 4x² − 10"

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
