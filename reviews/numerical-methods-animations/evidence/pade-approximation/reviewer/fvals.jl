using SpecialFunctions
for (nm, v) in [("Y0(10)", bessely(0,10.0)), ("Y0(0.3)", bessely(0,0.3)), ("gamma(4.5)", gamma(4.5)), ("gamma(-0.1)", gamma(-0.1)), ("J1(7.3)", besselj(1,7.3)), ("J0(9.1)", besselj(0,9.1)), ("Phi(1.2)", 0.5+0.5*erf(1.2/sqrt(2.0)))]
    println(nm, " ", repr(v))
end
