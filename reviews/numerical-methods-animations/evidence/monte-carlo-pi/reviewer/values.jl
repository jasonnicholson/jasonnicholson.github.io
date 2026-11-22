using Random
n_seq = [100, 400, 1600, 6400, 10000]
Random.seed!(12345)
xs = rand(10000); ys = rand(10000)
inside = xs .^ 2 .+ ys .^ 2 .<= 1.0
for n in n_seq
  m = count(inside[1:n]); ph = 4m/n; err = abs(pi-ph)
  sd = 4*sqrt((pi/4)*(1-pi/4)/n)
  println("n=$n m=$m k=$(n-m) pi_hat=$(round(ph;digits=6)) err=$(round(err;digits=6)) 1/sqrt(n)=$(round(1/sqrt(n);digits=6)) sd=$(round(sd;digits=6)) z=$(round(err/sd;digits=3))")
end
# also write raw points for independent check
open("pts.txt","w") do f; for i in 1:10000; println(f, xs[i], " ", ys[i]); end; end
