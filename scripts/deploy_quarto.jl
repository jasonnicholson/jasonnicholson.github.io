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

# Back up the SITE_DIR/.git file (Quarto may wipe it out)
dot_git_file = joinpath(SITE_DIR, ".git")
dot_git_contents = nothing
dot_git_contents = read(dot_git_file, String)
@info "Backed up $dot_git_file"

# Render the Quarto site
run_cmd(`quarto render`)

# Restore backed-up .git file
open(dot_git_file, "w") do io
  write(io, dot_git_contents)
end
@info "Restored $dot_git_file"

# Get current commit hash
current_hash = readchomp(`git rev-parse --short HEAD`)

cd(SITE_DIR) do
  @info "Current directory: $(pwd())"
  try
    run_cmd(`git add --all .`)
    run_cmd(`git commit -m "Deploy Quarto site to gh-pages $current_hash"`)
    run_cmd(`git push --force origin gh-pages`)
  catch e
    # if there are no changes to commit, continue
  end  
end

if !haskey(ENV, "CI")
  @info "CI not detected; cleaning up worktree and gh-pages branch"
  try
    run_cmd(`git worktree remove $SITE_DIR --force`)
    run_cmd(`git branch -D gh-pages`)
  catch e
    @warn "Failed to clean up: $e"
  end
else
  @info "CI detected; skipping worktree cleanup"
end
