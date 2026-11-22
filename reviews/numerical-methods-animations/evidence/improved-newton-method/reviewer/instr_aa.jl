# newtonimpaa.jl
# Improved Newton Method animation: Standard Newton-Raphson at a double root
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.3
# Shows LINEAR (slow) convergence — standard Newton degrades at multiple roots.
# Produces: newtonimpaa.gif


# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.3
n_iters = 10

xlims = (0.6, 1.8)
ylims = (-0.1, 1.3)

title_str = "Standard Newton: f(x) = x³−3x+2 (double root at x=1)"

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
