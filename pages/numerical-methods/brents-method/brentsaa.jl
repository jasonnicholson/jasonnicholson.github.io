# brentsaa.jl
# Brent's Method animation: f(x) = 4x³ - 16x² + 17x - 4, interval [0, 1]
# Root (i) ≈ 0.3224. Shows bracket narrowing with method annotation.
# Produces: brentsaa.gif

using Plots
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
            # Inverse Quadratic Interpolation
            s = (a * fb * fc / ((fa - fb) * (fa - fc)) +
                 b * fa * fc / ((fb - fa) * (fb - fc)) +
                 c * fa * fb / ((fc - fa) * (fc - fb)))
            method = "IQI"
        else
            # Secant
            s = b - fb * (b - a) / (fb - fa)
            method = "Secant"
        end

        # Brent's acceptance conditions — fall back to bisection if rejected
        mid = (a + b) / 2
        lo, hi = min(a, b), max(a, b)
        cond1 = !(lo < s < hi)                         # s outside [a,b]
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

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=600)
fplot = clamp.(f.(xplot), ylims[1] - 1, ylims[2] + 1)

method_colors = Dict("IQI" => :darkorange, "Secant" => :steelblue, "Bisection" => :purple, "init" => :gray)
method_labels = Dict("IQI" => "IQI", "Secant" => "Secant", "Bisection" => "Bisect", "init" => "")

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

    plot!(xplot, fplot; color=:magenta, lw=2, label="f(x)")

    # Shaded bracket region
    bx = [a_cur, b_cur, b_cur, a_cur, a_cur]
    by = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bx, by; fill=true, fillalpha=0.10, fillcolor=:steelblue, lw=0, label="")
    vline!([a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket")

    # Best estimate b (before min/max sort — it's whichever gives smaller |f|)
    b_best = abs(f(st.a)) < abs(f(st.b)) ? st.a : st.b
    b_best = clamp(b_best, xlims[1], xlims[2])
    scatter!([b_best], [f(b_best)]; color=:red, ms=8,
             label="b = $(round(b_best; digits=6))")

    annotate!(xlims[1] + 0.02*(xlims[2]-xlims[1]), ylims[2] - 0.04*(ylims[2]-ylims[1]),
              text("Step $(i-1): $meth", :left, 10, col))
end

gif(anim, joinpath(@__DIR__, "brentsaa.gif"); fps=2)
println("Saved: brentsaa.gif")
