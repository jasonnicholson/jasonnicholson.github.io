# newtonimpee.jl
# Improved Newton Method animation: Standard Newton diverges on arctan(x), x0=1.4
# f(x) = arctan(x), root at x=0; x0=1.4 is just above the critical convergence radius ~1.3917
# Standard Newton-Raphson diverges — iterates escape to larger |x| rather than converging.
# Produces: newtonimpee.gif


# --- Functions ---
f(x)  = atan(x)
fp(x) = 1.0 / (1.0 + x^2)

# --- Parameters ---
x0      = 1.4
n_iters = 6

xlims = (-4.0, 5.0)
ylims = (-1.8, 1.8)

title_str = "Standard Newton: f(x) = arctan(x), x₀=1.4 (divergent)"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])
end

println("== ", title_str)
for (k,x) in enumerate(xs)
  r6 = round(x; digits=6)
  println(rpad(k-1,3), " x=", repr(x), "  f=", repr(f(x)), "  fp=", repr(fp(x)), "  label6=", r6, " label4=", round(x;digits=4), " label2=", round(x;digits=2))
end
