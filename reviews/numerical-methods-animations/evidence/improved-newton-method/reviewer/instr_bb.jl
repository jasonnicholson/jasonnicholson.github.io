# newtonimpbb.jl
# Improved Newton Method animation: Method A (accelerated, m=2) at a double root
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.3
# Shows QUADRATIC (fast) convergence — accelerated Newton restores quadratic rate.
# Formula: x_{n+1} = x_n - m * f(x_n)/f'(x_n), m=2
# Produces: newtonimpbb.gif


# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.3
n_iters = 5
m       = 2   # multiplicity of the root

xlims = (0.6, 1.8)
ylims = (-0.1, 1.3)

title_str = "Method A (m=2): f(x) = x³−3x+2 (double root at x=1)"

# --- Pre-compute iterates using Method A ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - m * f(xs[i]) / fp(xs[i])
end

println("== ", title_str)
for (k,x) in enumerate(xs)
  r6 = round(x; digits=6)
  println(rpad(k-1,3), " x=", repr(x), "  f=", repr(f(x)), "  fp=", repr(fp(x)), "  label6=", r6, " label4=", round(x;digits=4), " label2=", round(x;digits=2))
end
