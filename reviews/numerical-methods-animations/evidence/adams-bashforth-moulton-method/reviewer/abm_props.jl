function abm4(f, t0, tf, y0, n_steps)
    h = (tf - t0) / n_steps
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    # Self-start with RK4 for y1, y2, y3.
    for i in 1:3
        t = ts[i]
        y = ys[i]
        k1 = f(t, y)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
        k4 = f(t + h, y + h * k3)
        ys[i + 1] = y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
    end

    for n in 4:n_steps
        fn = f(ts[n], ys[n])
        fn1 = f(ts[n - 1], ys[n - 1])
        fn2 = f(ts[n - 2], ys[n - 2])
        fn3 = f(ts[n - 3], ys[n - 3])

        y_pred = ys[n] + (h / 24.0) * (55.0 * fn - 59.0 * fn1 + 37.0 * fn2 - 9.0 * fn3)
        f_pred = f(ts[n + 1], y_pred)

        ys[n + 1] = ys[n] + (h / 24.0) * (9.0 * f_pred + 19.0 * fn - 5.0 * fn1 + fn2)
    end

    return ts, ys
end
using Printf
for (name,g,ex) in [("y=t^4, f=4t^3",(t,y)->4t^3,t->t^4), ("y=t^5, f=5t^4",(t,y)->5t^4,t->t^5),
                    ("y=t^4, f=4t^3+(y-t^4)",(t,y)->4t^3+(y-t^4),t->t^4)]
    ts,ys = abm4(g,0.0,1.0,0.0,20)
    @printf("%-24s max err = %.3e\n", name, maximum(abs.(ys .- ex.(ts))))
end
prev=NaN
for n in (10,20,40,80,160)
    ts,ys=abm4((t,y)->-2t*y,0.0,1.0,1.0,n); e=abs(ys[end]-exp(-1))
    @printf("script abm4, y=exp(-t^2), n=%3d err=%.3e ratio=%.2f\n",n,e,prev/e); global prev=e
end
for n in (50,100)
    ts,ys=abm4((t,y)->1-t*cbrt(y),0.0,5.0,1.0,n); @printf("problem n=%d y(5)=%.10f min y=%.3e\n",n,ys[end],minimum(ys))
end
