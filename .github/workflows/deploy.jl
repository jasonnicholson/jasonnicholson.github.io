# This script deploys to the gh-pages branch using a git worktree. It can
# be used locally or in CI environments.
#
# The worktree method is helpful because LFS items are committed
# as actual files and not pointers, which then works for GitHub Pages.


# Clean up local gh-pages branch and worktree if they exist if not running in CI
if !haskey(ENV, "CI")
  @info "CI not detected; checking for existing gh-pages worktree and branch to clean up"
  try
    run(`git worktree remove __site --force`)
    run(`git branch -D gh-pages`)
  catch e
    # Do nothing if they don't exist
  end
end


# Creates a local gh-pages branch with no files
# This must be done before building the site
run(`git worktree add --orphan -B gh-pages __site`)

# Get the current git commit hash
current_hash = readchomp(`git rev-parse --short HEAD`);

# NOTE
#   The steps below ensure that NodeJS and Franklin are loaded then it
#   installs highlight.js which is needed for the prerendering step
#   (code highlighting + katex prerendering).
#   Then the environment is activated and instantiated to install all
#   Julia packages which may be required to successfully build your site.
#   The last line should be `optimize()` though you may want to give it
#   specific arguments, see the documentation or ?optimize in the REPL.
# Build the site
using Pkg;
Pkg.activate(".");
Pkg.instantiate();
using NodeJS;
run(`$(npm_cmd()) install`);

using Franklin;
optimize(prerender=false);

# Deploy the site
cd("__site") do
  run(`git add --all .`)
  run(`git commit -m "Deploy to gh-pages $current_hash"`)
  run(`git push --force origin gh-pages`)
end

# If not running in CI, remove the temporary worktree and delete the
# local `gh-pages` branch. When `CI` is defined we assume the action
# runner or environment will manage cleanup and we skip these steps.
if !haskey(ENV, "CI")
  @info "CI not detected; cleaning up __site worktree and gh-pages branch"
  try
    run(`git worktree remove __site --force`)
    run(`git branch -D gh-pages`)
  catch e
    @warn "Failed to remove worktree __site and/or gh-pages branch: $e"
  end
else
  @info "CI detected; skipping worktree cleanup"
end

