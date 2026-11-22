# Instrumented copy of mr_iterates from madsreidaa.jl / madsreidab.jl (logic unchanged)
using Printf
function trace(f, fp, x0, n_iters, root; tolfp)
    x = Float64(x0); r0 = 2.5*abs(x0); labels=Symbol[]; xs=[x]
    for k in 1:n_iters
        fval=f(x); fpval=fp(x); f_sq=fval^2
        abs(fpval) < tolfp(fval) && break
        dz = fval/fpval; newton=dz; r=abs(dz); capped = r>r0
        r0_before=r0
        if capped; dz = dz*(r0/r); end
        r0 = r*5.0
        x_new=x-dz; fn_sq=f(x_new)^2; lab=:newton
        if !(fn_sq<f_sq)
            lab=:damped; improved=false
            for _ in 1:4
                dz*=0.5; x_new=x-dz; fn_sq=f(x_new)^2
                if fn_sq<f_sq; improved=true; break; end
            end
            !improved && (dz = dz*(-0.6); x_new=x-dz)
        end
        push!(labels,lab)
        e_old=abs(x-root); e_new=abs(x_new-root)
        @printf("k=%2d x=%.12f r0_in=%.4g |newton|=%.4g capped=%s |taken|/|newton|=%.6f %s err=%.3e ratio=%.5f  newton/err=%.4f\n",
            k,x,r0_before,r,capped,abs(dz)/r,lab,e_new,e_new/e_old, r/e_old)
        x=x_new; push!(xs,x)
        abs(f(x))<1e-10 && break
    end
    println("labels: ",labels); println("n frames: ",length(xs))
end
println("=== Case 1 (aa)"); trace(x->x^3-3x-1, x->3x^2-3, 3.0, 8, 1.8793852415718167; tolfp=v->1e-14)
println("=== Case 2 (ab)"); trace(x->x^3-3x+2, x->3x^2-3, 4.0, 14, 1.0; tolfp=v->1e-14*(1+abs(v)))
