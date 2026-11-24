# Extract the frames of a GIF so they can be looked at one by one.
# usage: julia giftools.jl <gif> <outdir>
# Writes every frame as frame_###.png, a contact sheet sheet.png (up to 12 evenly
# spaced frames, 4 per row) and frames.md5 (hashes of the decoded frames, for
# comparing two GIFs whose bytes differ). Uses the ffmpeg bundled with Plots.
# Put <outdir> outside the repository.
using Plots
gifpath, outdir = ARGS
mkpath(outdir)
ff(args...) = Plots.FFMPEG.exe("-v", "error", "-y", args...)
ff("-i", gifpath, joinpath(outdir, "frame_%03d.png"))
n = count(f -> startswith(f, "frame_"), readdir(outdir))
k = max(1, cld(n, 12)); rows = cld(cld(n, k), 4)
ff("-i", gifpath, "-vf", "select='not(mod(n\\,$k))',scale=420:-1,tile=4x$rows",
   "-frames:v", "1", "-vsync", "0", joinpath(outdir, "sheet.png"))
ff("-i", gifpath, "-pix_fmt", "rgb24", "-f", "framemd5", joinpath(outdir, "frames.md5"))
println(n, " frames")
