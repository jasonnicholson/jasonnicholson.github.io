# brentsaa.jl
# Brent's Method animation: f(x) = 4x³ - 16x² + 17x - 4, interval [0, 1]
# Root (i) ≈ 0.3224. Shows bracket narrowing with method annotation.
# Produces: brentsaa.gif


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
for (i,st) in enumerate(steps)
  bb = abs(f(st.a)) < abs(f(st.b)) ? st.a : st.b
  println(i-1, "  ", st.method, "  a=", st.a, "  b=", st.b, "  best=", bb, "  f(best)=", f(bb))
end
