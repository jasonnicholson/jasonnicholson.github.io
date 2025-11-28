#!/usr/bin/env julia
using Pkg
using Dates

# Minimal deploy script for Quarto sites. Mirrors the earlier deploy.jl
# workflow but uses `quarto render` to build the site into `__site`.

function run_cmd(cmd::Cmd)
    println("$cmd")
    run(cmd)
end

# If not running in CI, try to clean up any existing worktree so the
# script can start from a clean state.
if !haskey(ENV, "CI")
  try
    run_cmd(`git worktree remove __site --force`)
    run_cmd(`git branch -D gh-pages`)
  catch e
    # ignore if they don't exist
  end
end

# Create a gh-pages worktree
run_cmd(`git worktree add --orphan -B gh-pages __site`)

# Render the Quarto site
run_cmd(`quarto render`)

# Get current commit hash
current_hash = readchomp(`git rev-parse --short HEAD`)

cd("__site") do
  try
    run_cmd(`git add --all .`)
    run_cmd(`git commit -m "Deploy Quarto site to gh-pages $current_hash"`)
  catch e
    # if there are no changes to commit, continue
  end
  run_cmd(`git push --force origin gh-pages`)
end

if !haskey(ENV, "CI")
  @info "CI not detected; cleaning up __site worktree and gh-pages branch"
  try
    run_cmd(`git worktree remove __site --force`)
    run_cmd(`git branch -D gh-pages`)
  catch e
    @warn "Failed to clean up: $e"
  end
else
  @info "CI detected; skipping worktree cleanup"
end
