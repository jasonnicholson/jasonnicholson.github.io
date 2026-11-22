# Copy of the iterate-computation sections of aitkenab.jl and aitkenef.jl (no plotting)
function caseA()
    f(x)=x^3-3x+2; df(x)=3x^2-3; root=1.0; x0=2.0; n_steff=7
    xS=Vector{Float64}(undef,n_steff+1); xS[1]=x0; brk=0
    for i in 1:n_steff
        q1=xS[i]-f(xS[i])/df(xS[i]); q2=q1-f(q1)/df(q1); denom=q2-2*q1+xS[i]
        println("  i=$i x=$(xS[i]) q1=$q1 q2=$q2 denom=$denom")
        if abs(denom)<1e-15; xS[i+1:end].=xS[i]; brk=i; break; end
        xS[i+1]=xS[i]-(q1-xS[i])^2/denom
    end
    println("Case1 break at i=$brk")
    for (k,x) in enumerate(xS); println("k=$(k-1) x=$x err=$(abs(x-root)) log10=$(log10(max(abs(x-root),1e-16)))"); end
end
function caseC()
    f(x)=x^6-7x^4+15x^2-9; df(x)=6x^5-28x^3+30x; root=sqrt(3.0); x0=1.5; n_steff=6
    xS=Vector{Float64}(undef,n_steff+1); xS[1]=x0; brk=""
    for i in 1:n_steff
        dfi=df(xS[i]); if abs(dfi)<1e-14; xS[i+1:end].=xS[i]; brk="dfi@$i"; break; end
        q1=xS[i]-f(xS[i])/dfi; dfq1=df(q1)
        if abs(dfq1)<1e-14; xS[i+1:end].=q1; brk="dfq1@$i"; break; end
        q2=q1-f(q1)/dfq1; denom=q2-2*q1+xS[i]
        println("  i=$i x=$(xS[i]) f=$(f(xS[i])) q1=$q1 q2=$q2 denom=$denom")
        if abs(denom)<1e-15; xS[i+1:end].=xS[i]; brk="denom@$i"; break; end
        xS[i+1]=xS[i]-(q1-xS[i])^2/denom
    end
    println("Case3 break: $brk")
    for (k,x) in enumerate(xS); println("k=$(k-1) x=$x err=$(abs(x-root)) log10=$(log10(max(abs(x-root),1e-16)))"); end
end
caseA(); caseC()
