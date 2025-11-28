#!/usr/bin/env julia
using Pkg
using Dates

SITE_DIR = abspath(joinpath(@__DIR__, "..","_site"))

@info "SITE_DIR: $SITE_DIR"

# Minimal deploy script for Quarto sites.
# Uses `quarto render` to build the site.

function run_cmd(cmd::Cmd)
    println("$cmd")
    run(cmd)
end

# If not running in CI, try to clean up any existing worktree so the
# script can start from a clean state.
if !haskey(ENV, "CI")
  try
    run_cmd(`git clean -xfd`)
    rm(SITE_DIR, force=true, recursive=true)
    run_cmd(`git worktree remove $SITE_DIR --force`)
    run_cmd(`git branch -D gh-pages`)
  catch e
    # ignore if they don't exist
  end
end

# Create a gh-pages worktree
run_cmd(`git worktree add --orphan -B gh-pages $SITE_DIR`)

# Render the Quarto site
run_cmd(`quarto render`)

# Get current commit hash
current_hash = readchomp(`git rev-parse --short HEAD`)

cd(SITE_DIR) do
  @info "Current directory: $(pwd())"
  try
    run_cmd(`git add --all -f .`)
    run_cmd(`git commit -m "Deploy Quarto site to gh-pages $current_hash"`)
    run_cmd(`git push --force origin gh-pages`)
  catch e
    # if there are no changes to commit, continue
  end  
end

# if !haskey(ENV, "CI")
#   @info "CI not detected; cleaning up worktree and gh-pages branch"
#   try
#     run_cmd(`git worktree remove $SITE_DIR --force`)
#     run_cmd(`git branch -D gh-pages`)
#   catch e
#     @warn "Failed to clean up: $e"
#   end
# else
#   @info "CI detected; skipping worktree cleanup"
# end
