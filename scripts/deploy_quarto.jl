#!/usr/bin/env julia

using Dates

SITE_DIR = abspath(joinpath(@__DIR__, "..","_site"))

@info "SITE_DIR: $SITE_DIR"

# Minimal deploy script for Quarto sites.
# Uses `quarto render` to build the site.

function run_cmd(cmd::Cmd)
    println("$cmd")
    run(cmd)
end

function try_run_cmd(cmd::Cmd)
  try
    run_cmd(cmd)
    return true
  catch
    return false
  end
end

function worktree_list_porcelain()
  try
    return read(`git worktree list --porcelain`, String)
  catch
    return ""
  end
end

function site_is_registered_worktree(site_dir::AbstractString)
  wt = worktree_list_porcelain()
  return occursin("worktree $(site_dir)", wt)
end

function ensure_site_worktree!(site_dir::AbstractString)
  dot_git_file = joinpath(site_dir, ".git")

  function dir_is_empty(dir::AbstractString)
    try
      return isempty(readdir(dir))
    catch
      return true
    end
  end

  if isfile(dot_git_file)
    @info "Found worktree gitdir file: $dot_git_file"
    return
  end

  if site_is_registered_worktree(site_dir)
    @warn "Worktree registered but $dot_git_file is missing; attempting repair"
    try_run_cmd(`git worktree repair $site_dir`)
    if isfile(dot_git_file)
      @info "Repair restored $dot_git_file"
      return
    end
    @warn "Repair did not restore $dot_git_file; pruning and re-adding worktree"
    try_run_cmd(`git worktree prune`)
  end

  # If we reach here, the site dir is not a registered worktree.
  # It's safe to delete it to allow creating the worktree cleanly.
  if isdir(site_dir)
    @warn "Existing $site_dir is not a worktree; deleting it to create gh-pages worktree"
    rm(site_dir; recursive=true, force=true)
  end

  mkpath(site_dir)
  @info "Creating gh-pages worktree at $site_dir"
  run_cmd(`git worktree add --force --orphan -B gh-pages $site_dir`)
end

# Do not delete _site. Instead, reuse/repair the persistent worktree.
if !haskey(ENV, "CI")
  try_run_cmd(`git worktree prune`)
end

ensure_site_worktree!(SITE_DIR)

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
    # Keep gh-pages as a single-commit branch by recreating an orphan commit
    run_cmd(`git checkout --orphan gh-pages-tmp`)
    try_run_cmd(`git rm -r --cached .`)
    run_cmd(`git add --all .`)
    run_cmd(`git commit -m "Deploy Quarto site to gh-pages $current_hash"`)
    run_cmd(`git branch -M gh-pages`)
    run_cmd(`git push --force origin gh-pages`)
  catch e
    # if there are no changes to commit, continue
  end  
end

@info "Leaving $SITE_DIR worktree in place for next deploy"

