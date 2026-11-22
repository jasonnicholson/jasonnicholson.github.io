# newtonimpdd.jl
# Improved Newton Method animation: Method A (accelerated, m=3) at a triple root
# f(x) = x^4 - x^3 - 3x^2 + 5x - 2 = (x-1)^3*(x+2), triple root at x=1, x0=1.3
# Shows QUADRATIC (fast) convergence restored by Method A with correct multiplicity m=3.
# Formula: x_{n+1} = x_n - m * f(x_n)/f'(x_n), m=3
# Produces: newtonimpdd.gif


# --- Functions ---
f(x)  = x^4 - x^3 - 3x^2 + 5x - 2
fp(x) = 4x^3 - 3x^2 - 6x + 5

# --- Parameters ---
x0      = 1.3
n_iters = 5
m       = 3   # multiplicity of the root

xlims = (0.5, 1.6)
ylims = (-0.05, 0.5)

title_str = "Method A (m=3): f(x) = x⁴−x³−3x²+5x−2 (triple root at x=1)"

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
