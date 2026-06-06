# brentsbb.jl
# Brent's Method animation: f(x) = tan(x) - 2x, interval [0.5, 1.5]
# Non-trivial root ≈ 1.1656. Illustrates fast convergence vs slow Regula Falsi.
# Produces: brentsbb.gif

using Plots
gr()

# --- Parameters ---
f(x) = tan(x) - 2x

a0 = 0.5
b0 = 1.5
tol = 1e-10
n_iters = 16

xlims = (0.3, 1.65)
ylims = (-1.8, 8.0)

title_str = "Brent's Method: f(x) = tan(x) − 2x, [0.5, 1.5]"

# --- Brent's Method: pre-compute iteration history ---
struct BrentStep
    a::Float64
    b::Float64
    method::String
end

function run_brents(f, a, b, n_iters, tol)
    steps = BrentStep[]
    fa, fb = f(a), f(b)
    if abs(fa) < abs(fb)
        a, b = b, a
        fa, fb = fb, fa
    end
    c = a
    fc = fa
    mflag = true
    s = b
    d = 0.0

    push!(steps, BrentStep(a, b, "init"))

    for _ in 1:n_iters
        fa, fb, fc = f(a), f(b), f(c)
        if abs(fb) < tol || abs(b - a) < tol
            break
        end

        method = ""
        if fa != fc && fb != fc
            s = (a * fb * fc / ((fa - fb) * (fa - fc)) +
                 b * fa * fc / ((fb - fa) * (fb - fc)) +
                 c * fa * fb / ((fc - fa) * (fc - fb)))
            method = "IQI"
        else
            s = b - fb * (b - a) / (fb - fa)
            method = "Secant"
        end

        mid = (a + b) / 2
        lo, hi = min(a, b), max(a, b)
        cond1 = !(lo < s < hi)
        cond2 = mflag  && abs(s - b) >= abs(b - c) / 2
        cond3 = !mflag && abs(s - b) >= abs(c - d) / 2
        cond4 = mflag  && abs(b - c) < tol
        cond5 = !mflag && abs(c - d) < tol

        if cond1 || cond2 || cond3 || cond4 || cond5
            s = mid
            method = "Bisection"
            mflag = true
        else
            mflag = false
        end

        d = c
        c = b

        if f(a) * f(s) < 0
            b = s
        else
            a = s
        end

        if abs(f(a)) < abs(f(b))
            a, b = b, a
        end

        push!(steps, BrentStep(a, b, method))
    end
    return steps
end

steps = run_brents(f, a0, b0, n_iters, tol)

# --- Backdrop (clamp tan near asymptote) ---
xplot = range(xlims[1], xlims[2], length=800)
# Mask values near the tan asymptote (π/2 ≈ 1.5708)
fplot = [abs(x - pi/2) < 0.04 ? NaN : clamp(f(x), ylims[1]-0.5, ylims[2]+0.5)
         for x in xplot]

method_colors = Dict("IQI" => :darkorange, "Secant" => :steelblue, "Bisection" => :purple, "init" => :gray)

# --- Animation ---
anim = @animate for i in 1:length(steps)
    st = steps[i]
    a_cur, b_cur = min(st.a, st.b), max(st.a, st.b)

    meth = i == 1 ? "Start" : st.method
    col  = get(method_colors, st.method, :gray)

    plot(size=(700, 560),
         xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:bottomright, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")

    # Vertical asymptote indicator
    vline!([pi/2]; color=:gray, lw=1, ls=:dot, label="")

    plot!(collect(xplot), fplot; color=:magenta, lw=2, label="f(x)")

    # Shaded bracket
    bx = [a_cur, b_cur, b_cur, a_cur, a_cur]
    by = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bx, by; fill=true, fillalpha=0.10, fillcolor=:steelblue, lw=0, label="")
    vline!([a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket")

    # Best estimate
    b_best = abs(f(st.a)) < abs(f(st.b)) ? st.a : st.b
    fb_best = clamp(f(b_best), ylims[1], ylims[2])
    scatter!([b_best], [fb_best]; color=:red, ms=8,
             label="b = $(round(b_best; digits=6))")

    annotate!(xlims[1] + 0.02*(xlims[2]-xlims[1]), ylims[2] - 0.04*(ylims[2]-ylims[1]),
              text("Step $(i-1): $meth", :left, 10, col))
end

gif(anim, joinpath(@__DIR__, "brentsbb.gif"); fps=2)
println("Saved: brentsbb.gif")
