#!/usr/bin/env julia
# convert_frontmatter.jl
#
# Traverse the site content and convert TOML front matter (+++ ... +++)
# to YAML front matter (--- ... ---) for Quarto. Creates a backup of
# each converted file with the extension `.orig`.
#
# Usage:
#   julia scripts/convert_frontmatter.jl [path]
#
# If no path is provided, the current directory is used.
using TOML
using Dates

function to_yaml_value(x, indent=0)
    sp = " " ^ indent
    if isa(x, String)
        # Quote strings that contain colon or newlines
        if occursin(':', x) || occursin("\n", x) || isempty(x)
            return "\"" * replace(x, '"' => "\\\"") * "\""
        else
            return x
        end
    elseif isa(x, Bool)
        return x ? "true" : "false"
    elseif isa(x, Integer) || isa(x, Float64)
        return string(x)
    elseif isa(x, Vector)
        # simple list of scalars
        items = [to_yaml_value(v, indent+2) for v in x]
        return "\n" * join([sp * "- " * items[i] for i in 1:length(items)], "\n")
    elseif isa(x, Dict)
        lines = String[]
        for (k,v) in x
            val = to_yaml_value(v, indent+2)
            if startswith(val, "\n")
                push!(lines, "$(sp)$(k):$(val)")
            else
                push!(lines, "$(sp)$(k): $(val)")
            end
        end
        return "\n" * join(lines, "\n")
    else
        return string(x)
    end
end

function convert_file(path::String)
    text = read(path, String)
    # match TOML front matter at the start: +++ ... +++
    m = match(r"^\s*\+\+\+[\s\S]*?\+\+\+", text)
    if m !== nothing
        block = m.match
        inner = replace(block, r"^\s*\+\+\+" => "")
        inner = replace(inner, r"\+\+\+\s*$" => "")
        # Convert Julia `Date(YYYY, MM, DD)` expressions to ISO date strings
        # Replace occurrences like Date(2021, 05, 01) with "2021-05-01"
        pat = r"Date\(\s*(\d{4})\s*,\s*(\d{1,2})\s*,\s*(\d{1,2})\s*\)"
        inner2 = inner
        for m2 in eachmatch(pat, inner)
            y = m2.captures[1]; mo = m2.captures[2]; d = m2.captures[3]
            rep = "\"$(y)-$(lpad(mo,2,'0'))-$(lpad(d,2,'0'))\""
            inner2 = replace(inner2, m2.match => rep)
        end
        inner = inner2
        toml_table = TOML.parse(inner)
    else
        # No TOML front matter; check for YAML front matter and sanitize numeric title
        y = match(r"^\s*---[\s\S]*?---", text)
        if y === nothing
            return false
        end
        block = y.match
        # Replace `title: 404` (numeric) with quoted string `title: "404"`
        pat_title = r"(?m)^\s*(title:\s*)(\d+)\s*$"
        inner_block = block
        for m3 in eachmatch(pat_title, block)
            prefix = m3.captures[1]; num = m3.captures[2]
            rep = "$(prefix)\"$(num)\"\n"
            inner_block = replace(inner_block, m3.match => rep)
        end
        newblock = inner_block
        if newblock != block
            out = newblock * "\n" * lstrip(replace(text, block=>""), '\n')
            write(path, out)
            return true
        end
        return false
    end
    # Convert Julia `Date(YYYY, MM, DD)` expressions to ISO date strings
    # Replace occurrences like Date(2021, 05, 01) with "2021-05-01"
    pat = r"Date\(\s*(\d{4})\s*,\s*(\d{1,2})\s*,\s*(\d{1,2})\s*\)"
    inner2 = inner
    for m in eachmatch(pat, inner)
        y = m.captures[1]; mo = m.captures[2]; d = m.captures[3]
        rep = "\"$(y)-$(lpad(mo,2,'0'))-$(lpad(d,2,'0'))\""
        inner2 = replace(inner2, m.match => rep)
    end
    inner = inner2
    toml_table = TOML.parse(inner)

    # serialize to YAML
    yaml_lines = String[]
    push!(yaml_lines, "---")
    for (k,v) in toml_table
        # Ensure title is always a YAML string (some pages use numeric titles like 404)
        if k == "title"
            val = "\"" * replace(string(v), '"' => "\\\"") * "\""
        else
            val = to_yaml_value(v, 0)
        end
        if startswith(val, "\n")
            push!(yaml_lines, "$(k):$(val)")
        else
            push!(yaml_lines, "$(k): $(val)")
        end
    end
    push!(yaml_lines, "---")

    content_after = replace(text, block => "")
    out = join(yaml_lines, "\n") * "\n" * lstrip(content_after, '\n')

    # Write converted content in-place (no .orig backups; git can restore if needed)
    write(path, out)
    return true
end

function walk_and_convert(root::String)
    exts = Set([".md", ".markdown"]) 
    for (rootdir, dirs, files) in walkdir(root)
        # skip __site, .git, _site, and .github
        if occursin("__site", rootdir) || occursin(".git", rootdir) || occursin(".github", rootdir)
            continue
        end
        for f in files
            ext = lowercase(splitext(f)[2])
            if ext in exts
                path = joinpath(rootdir, f)
                try
                    converted = convert_file(path)
                    if converted
                        println("Converted: ", path)
                    end
                catch e
                    @warn "Failed to convert $path: $e"
                end
            end
        end
    end
end

function main()
    root = length(ARGS) >= 1 ? ARGS[1] : pwd()
    walk_and_convert(root)
end

main()
