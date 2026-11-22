# brentsaa.jl
# Brent's Method animation: f(x) = 4x³ - 16x² + 17x - 4, interval [0, 1]
# Root ≈ 0.3285. Shows bracket narrowing with method annotation.
# Produces: brentsaa.gif

using Plots
using Printf
gr()

# --- Parameters ---
f(x) = 4x^3 - 16x^2 + 17x - 4

a0 = 0.0
b0 = 1.0
tol = 1e-10
n_iters = 14

xlims = (-0.15, 3.1)
ylims = (-4.5, 8.5)

title_str = "Brent's Method: f(x) = 4x³ − 16x² + 17x − 4"

# --- Brent's Method (Brent's ZEROIN, 1973): pre-compute iteration history ---
# b = current best approximation, c = contrapoint (the root lies between b and c),
# a = previous value of b (or a == c). Interpolation (IQI if a != c, secant if a == c)
# is accepted only if it goes less than about 3/4 of the way from b to c and is smaller
# than half the step before last; otherwise the step is a bisection.
struct BrentStep
    b::Float64
    c::Float64
    method::String
end

function run_brents(f, a, b, n_iters, tol)
    steps = BrentStep[]
    fa, fb = f(a), f(b)
    c, fc = a, fa
    d = e = b - a
    method = "init"

    for it in 0:n_iters
        # Keep the root between b and c
        if fb * (fc / abs(fc)) > 0
            c, fc = a, fa
            d = e = b - a
        end
        # Make b the endpoint with the smaller |f|
        if abs(fc) < abs(fb)
            a, b, c = b, c, b
            fa, fb, fc = fb, fc, fb
        end
        push!(steps, BrentStep(b, c, method))

        tol1 = 2 * eps(Float64) * abs(b) + tol / 2
        xm = (c - b) / 2
        if abs(xm) <= tol1 || fb == 0 || it == n_iters
            break
        end

        method = "Bisection"
        if abs(e) >= tol1 && abs(fa) > abs(fb)
            s = fb / fa
            if a == c
                # Secant (only two distinct points)
                p = 2 * xm * s
                q = 1 - s
                cand = "Secant"
            else
                # Inverse quadratic interpolation through a, b, c
                q = fa / fc
                r = fb / fc
                p = s * (2 * xm * q * (q - r) - (b - a) * (r - 1))
                q = (q - 1) * (r - 1) * (s - 1)
                cand = "IQI"
            end
            if p > 0
                q = -q
            else
                p = -p
            end
            # Brent's acceptance test — fall back to bisection if rejected
            if 2p < 3 * xm * q - abs(tol1 * q) && p < abs(e * q / 2)
                e = d
                d = p / q
                method = cand
            else
                d = xm
                e = d
            end
        else
            d = xm
            e = d
        end

        a, fa = b, fb
        if abs(d) > tol1
            b += d
        else
            b += copysign(tol1, xm)   # step shorter than tol1: move by tol1 instead
            method = "Min step"
        end
        fb = f(b)
    end
    return steps
end

steps = run_brents(f, a0, b0, n_iters, tol)

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=600)
fplot = clamp.(f.(xplot), ylims[1] - 1, ylims[2] + 1)

method_colors = Dict("IQI" => :darkorange, "Secant" => :steelblue, "Bisection" => :purple, "Min step" => :gray, "init" => :gray)
method_labels = Dict("IQI" => "IQI", "Secant" => "Secant", "Bisection" => "Bisect", "init" => "")

# --- Animation ---
anim = @animate for i in 1:length(steps)
    st = steps[i]
    a_cur, b_cur = min(st.b, st.c), max(st.b, st.c)

    meth = i == 1 ? "Start" : st.method
    col  = get(method_colors, st.method, :gray)

    plot(size=(700, 560),
         xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:bottomright, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")

    plot!(xplot, fplot; color=:magenta, lw=2, label="f(x)")

    # Shaded bracket region
    bx = [a_cur, b_cur, b_cur, a_cur, a_cur]
    by = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bx, by; fill=true, fillalpha=0.10, fillcolor=:steelblue, lw=0, label="")
    vline!([a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket")

    # Best estimate b (the bracket endpoint with the smaller |f|)
    b_best = st.b
    b_best = clamp(b_best, xlims[1], xlims[2])
    scatter!([b_best], [f(b_best)]; color=:red, ms=8,
             label=@sprintf("b = %.10f, |c−b| = %.1e", st.b, abs(st.c - st.b)))

    annotate!(xlims[1] + 0.02*(xlims[2]-xlims[1]), ylims[2] - 0.04*(ylims[2]-ylims[1]),
              text("Step $(i-1): $meth", :left, 10, col))
end

gif(anim, joinpath(@__DIR__, "brentsaa.gif"); fps=2)
println("Saved: brentsaa.gif")
