function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

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
        date = pagevar(surl, :date)
        title === nothing && (title = "Untitled")
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
        @info "processing post" url=(url === nothing ? "(nothing)" : url) surl=(surl === nothing ? "(nothing)" : surl) post=post title=(title === nothing ? "(nothing)" : title) date=(isnothing(date) ? "(nothing)" : string(date))
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

    @info "recent post" surl=surl title=(title === nothing ? "(nothing)" : title) date=string(date) rss=(isempty(string(rss_description)) ? "(none)" : string(rss_description))

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

"""
    {{redirect url}}

Creates a HTML layout for a redirect to `url`.
Taken from the the julialang.org site. 
https://github.com/JuliaLang/www.julialang.org/blob/90de0f3bf314796db210b6faeea55ed360721836/utils.jl#L43-L85
"""
function hfun_redirect(url)
  s = """
  <!-- REDIRECT -->
  <!doctype html>
  <html>
    <head>
      <meta http-equiv="refresh" content="0; url=$(url[1])">
    </head>
  </html>
  """
  return s
end