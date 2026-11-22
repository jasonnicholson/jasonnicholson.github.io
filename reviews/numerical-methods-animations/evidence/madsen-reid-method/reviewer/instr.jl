# Instrumented re-implementation copying the scripts' mr_iterates logic verbatim,
# plus tracing. No plotting.
using Printf
alt_real(dz, m) = dz*m*(-0.6)
function alt_c(dz::ComplexF64, m::Float64)
    complex((real(dz)*0.6 - imag(dz)*0.8)*m, (real(dz)*0.8 + imag(dz)*0.6)*m)
end
function trace(f, fp, x0, n_iters, r0init, alt, sattest)
    x = x0; r0 = r0init; xs=[x0]; labs=Symbol[]
    for it in 1:n_iters
        fval=f(x); fpval=fp(x); fsq=abs2(fval)
        if sattest(fval,fpval); println("  saddle break"); break; end
        dz = fval/fpval; newton=dz; r=abs(dz); clipped=false
        if r>r0; dz = (alt===alt_c ? alt(dz, r0/r) : dz*(r0/r)); clipped=true; end
        r0old=r0; r0 = r*5.0
        xn = x-dz; fn=abs2(f(xn)); lab=:newton; nh=0; altused=false
        if !(fn<fsq)
            lab=:damped; imp=false
            for _ in 1:4
                dz*=0.5; nh+=1; xn=x-dz; fn=abs2(f(xn)); if fn<fsq; imp=true; break; end
            end
            if !imp; dz=alt(dz,1.0); xn=x-dz; altused=true; end
        end
        push!(labs,lab)
        @printf("it %2d  x=%s  newton=%s r0(before)=%.4g clip=%s lab=%s halvings=%d alt=%s  |f|^2: %.6g -> %.6g  ratio(err)\n",
            it, string(xn), string(newton), r0old, clipped, lab, nh, altused, fsq, abs2(f(xn)))
        x=xn; push!(xs,x)
        abs(f(x))<1e-10 && break
    end
    xs, labs
end
println("=== aa"); f1(x)=x^3-3x-1; fp1(x)=3x^2-3
xa,la = trace(f1,fp1,3.0,8,7.5,alt_real,(f,fp)->abs(fp)<1e-14)
r1 = 2cos(pi/9)
for (k,x) in enumerate(xa); @printf("  x%d = %.15f  err=%.3e  label(frame)=%s\n", k-1, x, x-r1, round(x;digits=5)); end
println("=== ab"); f2(x)=x^3-3x+2
xb,lb = trace(f2,fp1,4.0,14,10.0,alt_real,(f,fp)->abs(fp)<1e-14*(1+abs(f)))
for k in 1:length(xb); e=xb[k]-1; @printf("  x%d = %.15f err=%.3e ratio=%s  legend=%s\n", k-1, xb[k], e, k>1 ? @sprintf("%.4f", e/(xb[k-1]-1)) : "-", round(xb[k];digits=5)); end
println("=== ac"); f3(z)=z^2+4; fp3(z)=2z
function tracec(n)
  z=complex(1.0,0.0); r0=5.0; zs=[z]
  for it in 1:n
    fz=f3(z); fpz=fp3(z); fsq=abs2(fz)
    dz = abs(fpz)<1e-14*(1+abs(fz)) ? alt_c(complex(r0*0.1,0.0),1.0) : fz/fpz
    r=abs(dz); clip=false
    if r>r0; dz=alt_c(dz,r0/r); clip=true; end
    r0o=r0; r0=r*5.0
    zn=z-dz; fn=abs2(f3(zn)); lab=:newton; nh=0; al=false
    if !(fn<fsq); lab=:damped; imp=false
      for _ in 1:4; dz*=0.5; nh+=1; zn=z-dz; fn=abs2(f3(zn)); if fn<fsq; imp=true; break; end; end
      if !imp; dz=alt_c(dz,1.0); zn=z-dz; al=true; end
    end
    @printf("it %d z=%s r0=%.4g clip=%s lab=%s halv=%d alt=%s |f|^2 %.6g -> %.6g  |z-2i|=%.3e\n", it, string(zn), r0o, clip, lab, nh, al, fsq, abs2(f3(zn)), abs(zn-2im))
    z=zn; push!(zs,z); abs(f3(z))<1e-10 && break
  end
  zs
end
zs=tracec(25)
for (k,z) in enumerate(zs); println("  z$(k-1) legend = $(round(real(z);digits=3)) + $(round(imag(z);digits=3))i"); end
