using Plots  # brings FileIO? try
using FileIO
d=ARGS[1]; n=parse(Int,ARGS[2])
fs=[Float64.(reinterpret(UInt8, collect(rawview(channelview(load(joinpath(d,"frame_"*lpad(i,3,'0')*".png"))))))) for i in 1:n]
