+++
title = "Setting Up a Franklin.jl Blog"
date = Date(2025,11,11)
rss_description = "Setting Up a Franklin.jl Blog"
tags = [""]
+++

Note, that this method is brittle. After I put this into practice and had multiple failures and spent hours and days troubleshooting, I opted for a static blog page that contains static links. I don't auto generate the page using the code below. I will come back to this after I understand some of the details better. For now, I am not using the method below.

1. Setup a new Franklin site.

```Julia
using Franklin
newsite("mySite", template="pure-sm")
```

2. Add the following code to your utils.jl file. The `newsite()` call created the `utils.jl` file.

```Julia
"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/blog/` folder.

Taken from the the julialang.org site and modified.
https://github.com/JuliaLang/www.julialang.org/blob/90de0f3bf314796db210b6faeea55ed360721836/utils.jl#L43-L85
"""
function hfun_blogposts()
  curyear = year(Dates.today())
  io = IOBuffer()
  for year in curyear:-1:2015
    ys = "$year"
    year < curyear && write(io, "\n**$year**\n")
    for month in 12:-1:1
      ms = lpad(string(month), 2, '0')
      base = joinpath("blog", ys, ms)
      isdir(base) || continue
      posts = filter!(p -> endswith(p, ".md"), readdir(base))
      nposts = length(posts)
      dates = Vector{Date}(undef, nposts)
      lines = Vector{String}(undef, nposts)
      for (i, post) in enumerate(posts)
        ps = splitext(post)[1]
        url = "/blog/$ys/$ms/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        title === nothing && (title = "Untitled")
        date = pagevar(surl, :date)
        # parse published date defensively; fall back to first of month
        if isnothing(date)
          date = Date(year, month, 1)
        else
          try
            # expect ISO format: yyyy-mm-dd
            date = Date(date, Dates.DateFormat("yyyy-mm-dd"))
          catch err1
            try
              # try generic parsing as a fallback
              date = Date(date)
            catch err2
              @warn "Failed to parse published date; falling back to first of month" surl = surl pubdate = date error = err2
              date = Date(year, month, 1)
            end
          end
        end
        dates[i] = date
        # format date as ISO yyyy-mm-dd for output
        lines[i] = "\n$date - [$title]($url)\n"
      end
      # sort by full Date (descending) so posts are antichronological
      order = sortperm(dates, rev=true)
      foreach(idx -> write(io, lines[idx]), order)
    end
  end
  # markdown conversion adds `<p>` beginning and end but
  # we want to avoid this to avoid an empty separator
  r = Franklin.fd2html(String(take!(io)), internal=true)
  return r
end

"""
    {{recentblogposts}}

Input the 3 latest blog posts.
Taken from the the julialang.org site and modified.
https://github.com/JuliaLang/www.julialang.org/blob/90de0f3bf314796db210b6faeea55ed360721836/utils.jl#L43-L85
"""
function hfun_recentblogposts()
  curyear = Dates.Year(Dates.today()).value
  ntofind = 3
  # collect recent posts dynamically; push! as we find them
  recent = Vector{Pair{String,Date}}()
  for year in curyear:-1:2019
    for month in 12:-1:1
      ms = lpad(string(month), 2, '0')
      base = joinpath("blog", "$year", "$ms")
      isdir(base) || continue
      posts = filter!(p -> endswith(p, ".md"), readdir(base))
      np = length(posts)
      dates = Vector{Date}(undef, np)
      surls = Vector{String}(undef, np)
      for (i, post) in enumerate(posts)
        ps = splitext(post)[1]
        surl = "blog/$year/$ms/$ps"
        surls[i] = surl
        # check :date front-matter only
        date = pagevar(surl, :date)
        # normalize into a Date; fall back to first of month
        if isnothing(date)
          d = Date(year, month, 1)
        elseif isa(date, Dates.Date)
          d = date
        else
          parsed = nothing
          try
            # expect ISO format yyyy-mm-dd
            parsed = Date(date, Dates.DateFormat("yyyy-mm-dd"))
          catch err1
            try
              parsed = Date(date)
            catch err2
              @warn "Failed to parse recent post date; falling back to first of month" surl = surl pubdate = date error = err2
            end
          end
          isnothing(parsed) && (d = Date(year, month, 1)) || (d = parsed)
        end
        dates[i] = d
      end
      # go over month posts in antichronological order by full Date
      sp = sortperm(dates, rev=true)
      for idx in sp
        surl = surls[idx]
        push!(recent, surl => dates[idx])
        length(recent) == ntofind && break
      end
      length(recent) == ntofind && break
    end
    length(recent) == ntofind && break
  end
  #
  io = IOBuffer()
  for (surl, date) in recent
    url = "/$surl/"
    title = pagevar(surl, :title)
    title === nothing && (title = "Untitled")
    # Check for rss_description first,
    # then fall back to rss.
    rss_description = pagevar(surl, :rss_description)
    if isnothing(rss_description)
      # some pages may still define `rss` explicitly (edge cases)
      rss_description = pagevar(surl, :rss)
      if isnothing(rss_description)
        rss_description = ""
      end
    end

    write(
      io,
      """
<div class="col-lg-4 col-md-12 blog">
  <a href="$url">$date - $title</a>
  <p>$rss_description</p>
</div>
"""
    )
  end
  return String(take!(io))
end
```

2. Create `blog` folder in the root of the new site.
3. Put an `index.md` (example below) in the `blog` folder. The `{{blogposts}}` and `{{recentblogposts}}` correspond to the `hfun_recentblogposts()` and `hfun_blogposts()` functions in `util.jl`.

  ```md
# Recent posts

{{recentblogposts}}

# Blog posts

{{blogposts}}
  ```

4. Create `yyyy/mm` folders in a `blog` folders. If you don't follow this format exact, the provided `hfun_recentblogposts()` and `hfun_blogposts()` won't find your posts.
5. Place your posts in the `yyyy/mm` folder. Names don't matter.
6. Make sure to define a Front Matters section for each post. The Front Matters must contain a `title` and `date` for the post to get parsed correctly by the `hfun_blogposts()` function. The `hfun_recentblogposts()` function has one extra requirement of `rss_description`. An example is shown below.

```text
+++
title = "Setting Up a Franklin.jl Blog"
date = Date(2025,11,11)
rss_description = "Setting Up a Franklin.jl Blog"
+++
```

~~~
<p><del>The blog post you are reading now was created from the above instructions.</del></p>
~~~