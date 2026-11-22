# brentsbb.jl
# Brent's Method animation: f(x) = tan(x) - 2x, interval [0.5, 1.5]
# Non-trivial root ≈ 1.1656. Illustrates fast convergence vs slow Regula Falsi.
# Produces: brentsbb.gif

using Printf

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

        s_cand = s
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

        @printf("  cand=%-6s s_cand=%.17g s=%.17g  f(s)=%.6e  final=%s mflag=%s c1=%s c2=%s c3=%s c4=%s c5=%s\n", (fa != fc && fb != fc) ? "IQI" : "Secant", s_cand, s, f(s), method, mflag, cond1,cond2,cond3,cond4,cond5)
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


for (k,st) in enumerate(steps)
    bb = abs(f(st.a)) < abs(f(st.b)) ? st.a : st.b
    @printf("step %2d %-9s a=%.17g b=%.17g width=%.3e f(a)=%.3e f(b)=%.3e label_b=%s\n", k-1, st.method, st.a, st.b, abs(st.b-st.a), f(st.a), f(st.b), string(round(bb; digits=6)))
end
