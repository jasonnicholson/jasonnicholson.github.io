# Note, the worktree method is helpful because LFS items are committed
# as actual files and not pointers. 

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

# No fail is set because of vba is language code blocks. The site highlights vba correctly 
# but there is no clear way to the prerender step how to use the vba language for code blocks.
using Franklin;
optimize(no_fail_prerender=true); 

# Deploy the site
cd("__site") do
    run(`git add .`);
    run(`git commit -m "Deploy to gh-pages $current_hash"`);
    run(`git push --force origin gh-pages`);
end