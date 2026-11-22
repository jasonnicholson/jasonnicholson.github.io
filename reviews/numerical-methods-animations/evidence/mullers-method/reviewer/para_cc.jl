# mullerscc.jl
# Muller's Method animation: Example 3
# f(x) = x^6 - 7x^4 + 15x^2 - 9 = (x^2-1)(x^2-3)^2
# Double root at p = sqrt(3) ≈ 1.7321 (near x=2 as stated in problem)
# Starting values: p0=1.3, p1=1.4, p2=1.5
# Produces: mullerscc.gif

using Plots
gr()

# --- Parameters ---
f(x) = x^6 - 7x^4 + 15x^2 - 9
p_init = [1.3, 1.4, 1.5]   # [p0, p1, p2]
n_iters = 8

xlims = (-2.5, 2.5)
ylims = (-12.0, 20.0)

title_str = "Muller's Method: f(x) = x⁶ - 7x⁴ + 15x² - 9"

# --- Muller's method step ---
function muller_step(p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0
    h1 = p2 - p1
    δ0 = (f1 - f0) / h0
    δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0)
    b = δ1 + h1 * d
    D = sqrt(complex(b^2 - 4 * f2 * d))
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return real(p2 - 2 * f2 / E)
end

# --- Lagrange parabola through 3 points ---
function lagrange_parabola(x, p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    L0 = (x - p1) * (x - p2) / ((p0 - p1) * (p0 - p2))
    L1 = (x - p0) * (x - p2) / ((p1 - p0) * (p1 - p2))
    L2 = (x - p0) * (x - p1) / ((p2 - p0) * (p2 - p1))
    return f0 * L0 + f1 * L1 + f2 * L2
end

# --- Pre-compute all iterates ---
history = Vector{NTuple{3,Float64}}(undef, n_iters + 1)
history[1] = (p_init[1], p_init[2], p_init[3])
for i in 1:n_iters
    (q0, q1, q2) = history[i]
    q3 = muller_step(q0, q1, q2, f)
    history[i+1] = (q1, q2, q3)
end
using Printf
pad = occursin("aa", @__FILE__) ? 0.3 : 0.2
for k in 1:n_iters+1
  (q0,q1,q2) = history[k]
  P(x) = lagrange_parabola(x,q0,q1,q2,f)
  nodeerr = maximum(abs.([P(q0)-f(q0), P(q1)-f(q1), P(q2)-f(q2)]))
  lo, hi = min(q0,q1,q2)-pad, max(q0,q1,q2)+pad
  xs = range(lo,hi,length=200); ys = P.(xs)
  crosses = any(ys .<= 0)
  vis = count(y -> ylims[1] <= y <= ylims[2], f.([q0,q1,q2]))
  if k <= n_iters
    nxt = history[k+1][3]
    @printf("frame %d: node mismatch %.1e; drawn x in [%.4f, %.4f]; parabola min on drawn range %.3e (crosses axis in drawn range: %s); next iterate %.6f inside drawn range: %s; P(next)=%.2e; points within ylims: %d/3; global min of P = %.3e\n", k, nodeerr, lo, hi, minimum(ys), crosses, nxt, lo<=nxt<=hi, P(nxt), vis, f(q2) - (begin h0=q1-q0;h1=q2-q1;d0=(f(q1)-f(q0))/h0;d1=(f(q2)-f(q1))/h1;d=(d1-d0)/(h1+h0);b=d1+h1*d; b^2/(4d) end))
  else
    @printf("frame %d: node mismatch %.1e (final frame)\n", k, nodeerr)
  end
end
