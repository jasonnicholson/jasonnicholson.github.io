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
                title === nothing && (title = "Untitled")
                pubdate = pagevar(surl, :published)
                # parse published date defensively; fall back to first of month
                if isnothing(pubdate)
                    date = Date(year, month, 1)
                else
                    try
                        # try original format (e.g. "1 January 2019")
                        date = Date(pubdate, Dates.DateFormat("d U Y"))
                    catch err1
                        try
                            # try generic ISO-ish parsing
                            date = Date(pubdate)
                        catch err2
                            @warn "Failed to parse published date; falling back to first of month" surl = surl pubdate = pubdate error = err2
                            date = Date(year, month, 1)
                        end
                    end
                end
                dates[i] = date
                y = Dates.year(date)
                mm = lpad(string(Dates.month(date)), 2, '0')
                dd = lpad(string(Dates.day(date)), 2, '0')
                lines[i] = "\n[$title]($url) $y-$mm-$dd \n"
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
Taken from the the julialang.org site. 
https://github.com/JuliaLang/www.julialang.org/blob/90de0f3bf314796db210b6faeea55ed360721836/utils.jl#L43-L85
"""
function hfun_recentblogposts()
    curyear = Dates.Year(Dates.today()).value
    ntofind = 3
    nfound = 0
    recent = Vector{Pair{String,Date}}(undef, ntofind)
    for year in curyear:-1:2019
        for month in 12:-1:1
            ms = "0"^(1 - div(month, 10)) * "$month"
            base = joinpath("blog", "$year", "$ms")
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days = zeros(Int, length(posts))
            surls = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps = splitext(post)[1]
                surl = "blog/$year/$ms/$ps"
                surls[i] = surl
                pubdate = pagevar(surl, :date)
                days[i] = isnothing(pubdate) ?
                          1 : day(Date(pubdate, Dates.DateFormat("d U Y")))
            end
            # go over month post in antichronological orders
            sp = sortperm(days, rev=true)
            for (i, surl) in enumerate(surls[sp])
                recent[nfound+1] = (surl => Date(year, month, days[sp[i]]))
                nfound += 1
                nfound == ntofind && break
            end
            nfound == ntofind && break
        end
        nfound == ntofind && break
    end
    #
    io = IOBuffer()
    for (surl, date) in recent
        url = "/$surl/"
        title = pagevar(surl, :title)
        title === nothing && (title = "Untitled")
        sdate = "$(day(date)) $(monthname(date)) $(year(date))"
        blurb = pagevar(surl, :rss)
        write(
            io,
            """
      <div class="col-lg-4 col-md-12 blog">
        <h3><a href="$url" class="title" data-proofer-ignore>$title</a>
        </h3><span class="article-date">$date</span>
        <p>$blurb</p>
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