using Dates, AnyAscii, PyCall, Base.Iterators

arxiv = pyimport("arxiv")
urllib = pyimport("urllib")



# Get and parse info from ArXiv.

function strip_version(eprint)
    parts = split(eprint, '/')
    parts[end] = first(split(parts[end], 'v'))

    return join(parts, '/')
end

const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

month_num(str) = findfirst(==(str), months)

author_subs = Dict(
    "M. L. Almeida" => "Almeida, M. L.",
    "Mafalda L. Almeida" => "Almeida, Mafalda L.",
    "R. G. Baets" => "Baets, R. G.",
    "J. -D. Bancal" => "Bancal, J.-D.",
    "C. -E. Bardyn" => "Bardyn, C.-E.",
    "A. Boyer de la Giroday" => "Boyer de la Giroday, A.",
    "Fernando G. S. L. Brandao" => "Brandao, Fernando G. S. L.",
    "Jonatan Bohr Brask" => "Brask, Jonatan Bohr",
    "Samuel L. Braunstein" => "Braunstein, Samuel L.",
    "Carlton M. Caves" => "Caves, Carlton M.",
    "N. J. Cerf" => "Cerf, N. J.",
    "Nicolas J. Cerf" => "Cerf, Nicolas J.",
    "M. W. L. Chee" => "Chee, M. W. L.",
    "Z. T. Chong" => "Chong, Z. T.",
    "Gonzalo de la Torre" => "de la Torre, Gonzalo",
    "Ronald de Wolf" => "de Wolf, Ronald",
    "Prathamesh S. Donvalkar" => "Donvalkar, Prathamesh S.",
    "Matthew B. Elliott" => "Elliott, Matthew B.",
    "Martianus Frederic Ezerman" => "Ezerman, Martianus Frederic",
    "Alexander L. Gaeta" => "Gaeta, Alexander L.",
    "R. D. Gill" => "Gill, R. D.",
    "S. -P. Gorza" => "Gorza, S.-P.",
    "L. P. Horwitz" => "Horwitz, L. P.",
    "M. A. Jafarizadeh" => "Jafarizadeh, M. A.",
    "Adrea R. Johnson" => "Johnson, Adrea R.",
    "Nick S. Jones" => "Jones, Nick S.",
    "Michael. R. E. Lamont" => "Lamont, Michael. R. E.",
    "L. P. Lamoureux" => "Lamoureux, L. P.",
    "L. -P. Lamoureux" => "Lamoureux, L.-P.",
    "T. Y. Lau" => "Lau, T. Y.",
    "Nicolas Le Thomas" => "Le Thomas, Nicolas",
    "Jacob S. Levy" => "Levy, Jacob S.",
    "T. C. H. Liew" => "Liew, T. C. H.",
    "Kian Ping Loh" => "Loh, Kian Ping",
    "Peter van Loock" => "Loock, Peter van",
    "T. A. Manning" => "Manning, T. A.",
    "S. A. A. Massar" => "Massar, S. A. A.",
    "D. N. Matsukevich" => "Matsukevich, D. N.",
    "J. -M. Merolla" => "Merolla, J.-M.",
    "Andre Allan Methot" => "Methot, Andre Allan",
    "A. B. Nagy" => "Nagy, A. B.",
    "B. K. L. Ng" => "Ng, B. K. L.",
    "A. T. Nguyen" => "Nguyen, A. T.",
    "J. L. Ong" => "Ong, J. L.",
    "Dmitrii V. Pasechnik" => "Pasechnik, Dmitrii V.",
    "M. K. Patra" => "Patra, M. K.",
    "Manas K. Patra" => "Patra, Manas K.",
    "K. Phan Huy" => "Phan Huy, K.",
    "Kien Phan Huy" => "Phan Huy, Kien",
    "M. B. Plenio" => "Plenio, M. B.",
    "Martin B. Plenio" => "Plenio, Martin B.",
    "E. S. Polzik" => "Polzik, E. S.",
    "Marco Túlio Quintino" => "Quintino, Marco Túlio",
    "Ana Belén Sainz" => "Sainz, Ana Belén",
    "John H. Selby" => "Selby, John H.",
    "S. K. Selvaraja" => "Selvaraja, S. K.",
    "Shankar Kumar Selvaraja" => "Selvaraja, Shankar Kumar",
    "John E. Sipe" => "Sipe, John E.",
    "Le Phuc Thinh" => "Thinh, Le Phuc",
    "Hans Raj Tiwary" => "Tiwary, Hans Raj",
    "Minh Cong Tran" => "Tran, Minh Cong",
    "Peter van der Gulik" => "van der Gulik, Peter",
    "Ron van der Meyden" => "van der Meyden, Ron",
    "Guy Van der Sande" => "Van der Sande, Guy",
    "Thomas van Himbeeck" => "van Himbeeck, Thomas",
    "Thomas Van Himbeeck" => "Van Himbeeck, Thomas",
    "D. van Thourhout" => "van Thourhout, D.",
    "Dries Van Thourhout" => "Van Thourhout, Dries",
    "Andrés F. Varón" => "Varón, Andrés F.",
    "B. T. T. Yeo" => "Yeo, B. T. T.",
    "Emmanuel Zambrini Cruzeiro" => "Zambrini Cruzeiro, Emmanuel"
)

unknown_subs = Dict()

# https://arxiv.org/abs/1209.3129 published here but doesn't seem to have a
# DOI:
#   https://dblp.org/db/conf/nips/nips2012.html
#
# https://arxiv.org/abs/1612.08606 seems to have been republished on ArXiv
# as https://arxiv.org/abs/2008.11247.

const missing_doi = Dict(
    "1908.11210" => "10.3389/fphy.2019.00138",
    "1611.06781" => "10.1038/s41467-019-09505-2",
    "1310.4125" => "10.1088/1751-8113/48/2/025302",
    "1111.0837" => "10.1145/2716307",
    "1102.1030" => "10.1364/OL.35.003483",
    "0909.2832" => "10.1016/j.jtbi.2009.09.004",
    "0705.1274" => "10.1364/OL.32.002819", # Some changes to title/abstract.
    "physics/0507189" => "10.1103/PhysRevE.72.066617"
)

function asub(author)
    if haskey(author_subs, author)
        return author_subs[author]
    elseif haskey(unknown_subs, author)
        return unknown_subs[author]
    else
        names = split(author)
        n_names = length(names)

        if (n_names == 1)
            return author
        end

        reformatted = names[end] * ", " * join(names[1:(end-1)], " ")

        if (length(names) > 2)
            println(stderr, "Warning: substituting \"", author,
                    "\" => \"", reformatted, "\".")
            unknown_subs[author] = reformatted
        end

        return reformatted
    end
end


const title_subs = Dict(
    "1510.00248" => "Random `choices' and the locality loophole"
)

fixlabel(label) = join(split(anyascii(label)), '_')

function arxiv2dict(paper)
    authors = [asub(a.name) for a in paper.authors]
    eprint = strip_version(paper.get_short_id())
    title = (haskey(title_subs, eprint) ? title_subs[eprint] : paper.title)
    date = paper.published
    year = string(Dates.year(date))
    month = months[Dates.month(date)]
    day = string(Dates.day(date))
    firstauthor = first(split(first(authors), ", "))
    label =  fixlabel(firstauthor) * "_" * string(year)

    result = Dict("type" => "article",
                  "label" => label,
                  "title" => title,
                  "author" => authors,
                  "year" => year,
                  "month" => month,
                  "day" => day,
                  "archivePrefix" => "ar{X}iv",
                  "eprint" => eprint,
                  "primaryClass" => paper.primary_category)

    if !isnothing(paper.doi)
        result["doi"] = paper.doi
    elseif haskey(missing_doi, eprint)
        result["doi"] = missing_doi[eprint]
    end

    return result
end

"""
Get information about papers matching an ArXiv search and convert results as
a Julia dictionary.
"""
function arxiv_search(query, sort_by=arxiv.SortCriterion.SubmittedDate)
    search = arxiv.Search(query=query, sort_by=sort_by)

    return [arxiv2dict(p) for p in search.results()]
end



# Get and parse info from doi.org

function doi_request(doi)
    doi_req = urllib.request.Request("http://doi.org/" * doi)
    #doi_req.add_header("Accept", "application/x-bibtex")
    #doi_req.add_header("Accept", "text/bibliography; style=bibtex")
    doi_req.add_header("Accept", "text/x-bibliography; style=bibtex")    

    f = urllib.request.urlopen(doi_req)
    result = f.read()
    f.close()

    return result
end

function closing_brace(str, ind)
    braces = 1
    max_ind = lastindex(str)

    while (braces > 0)
        ind = nextind(str, ind)

        if (ind > max_ind)
            break
        end

        c = str[ind]

        if (c == '{')
            braces += 1
        elseif (c == '}')
            braces -= 1
        end
    end

    return ind
end

function brace_content(str, start)
    start = findnext('{', str, start)
    close = closing_brace(str, start)
    return str[nextind(str, start) : prevind(str, close)]
end

function next_entry(str, pos)
    next(i) = nextind(str, i)
    prev(i) = prevind(str, i)

    nxt = findnext(", ", str, pos)

    if isnothing(nxt)
        return nothing
    end
    
    pos = next(nxt[2])
    sep = findnext('=', str, pos)

    fieldname = str[pos : prev(sep)]

    obrace = findnext('{', str, next(sep))
    cbrace = closing_brace(str, obrace)

    value = str[next(obrace) : prev(cbrace)]

    return strip(fieldname), strip(value), cbrace
end

function parse_entries(content, start=firstindex(content))
    result = Dict{String,Any}()
    
    pos = start
    entry = next_entry(content, pos)

    while !isnothing(entry)
        (fieldname, value, pos) = entry
        result[lowercase(fieldname)] = value
        entry = next_entry(content, pos)
    end

    return result
end
                 
function parse_bibtex(str)
    j = nextind(str, findfirst('@', str))
    k = findnext('{', str, j)

    type = strip(str[j : prevind(str, k)])
    content = brace_content(str, k)
    result = parse_entries(content)
    result["type"] = type

    result["author"] = split(result["author"], " and ")
    
    surname = first(split(first(result["author"]), ','))
    label = fixlabel(surname) * '_' * result["year"]
    result["label"] = label

    return result
end

# Crossref doesn't provide pages for all journals or publishers.
# Problematic ones:
#   10.1007/ -> Quantum Information Processing (Springer).
#   10.1038/ -> Nature Communications, Scientific Reports (Nature).
#
# Comment 'X' means that the pages seems to be contained in the DOI and could
# be extracted programmatically.
const missing_pages = Dict(
    "10.3389/fphy.2019.00138" => "138", # X
    "10.1007/s11128-021-03326-3" => "396",
    "10.1007/s11128-020-02959-0" => "35",
    "10.1007/978-3-642-35656-8_9" => "107--115",
    "10.1007/978-1-4614-0769-0_21" => "601--634",
    "10.1038/s41467-019-09505-2" => "1701",
    "10.1038/s41467-018-06255-5" => "4244",
    "10.1038/s41467-018-03254-4" => "847",
    "10.1038/srep03901" => "3901", # X
    "10.1038/srep00287" => "287", # X
    "10.1038/ncomms1244" => "238"
)

# Crossref doesn't put a space before the 'psi' in these titles.
# Below is fine for the website but they need to be changed to $\psi$ for
# inclusion in Latex.
const doi_title_subs = Dict(
    "10.1103/PhysRevA.88.032112"
    => "Experimental refutation of a class of ψ-epistemic models",
    "10.1103/PhysRevLett.111.090402"
    => "No-Go Theorems for ψ-Epistemic Models Based on a Continuity Assumption"
)

function lookup_doi(doi)
    result = doi_request(doi)
    entry = parse_bibtex(result)

    if haskey(doi_title_subs, doi)
        entry["title"] = doi_title_subs[doi]
    end

    if !haskey(entry, "pages")
        if haskey(missing_pages, doi)
            entry["pages"] = missing_pages[doi]
        elseif contains(entry["publisher"], "American Physical Society")
            entry["pages"] = last(split(doi, '.'))
        else
            println(stderr, "Warning: Paper https://doi.org/", doi,
                    " missing pages.")
            entry["pages"] = ""
        end
    end

    return entry
end



function add_from_doi!(entry)
    if !haskey(entry, "doi")
        return entry
    end

    doi = entry["doi"]

    if isnothing(doi)
        return entry
    else
        # Throw away ArXiv publication date, even if we didn't get one from
        # the DOI.
        delete!(entry, "year")
        delete!(entry, "month")
        delete!(entry, "day")

        # Add/overwrite with data from DOI lookup, except keep original DOI.
        cref_entry = lookup_doi(doi)
        delete!(cref_entry, "doi")
        delete!(cref_entry, "url")  # This is just https://doi.org/<DOI>.
        entry = merge!(entry, cref_entry)

        return entry
    end
end



function sort_entries(entries)
    f(e) = [e["year"], month_num(e["month"]), e["author"], e["title"]]
    return sort(entries, by=f, rev=true)
end



function arxiv_entries(search)
    entries = arxiv_search(search)
    return sort_entries([add_from_doi!(e) for e in entries])
end


                
const fields = [
    "title",
    "author",
    "journal",
    "publisher",
    "volume",
    "number",
    "issue",
    "pages",
    "year",
    "month",
    "day",
    "doi",
    "url",
    "isbn",
    "issn",
    "archivePrefix",
    "eprint",
    "primaryClass"
]

const fieldlen = maximum(length.(fields))
const textwidth = 78



function print_val(value, lmargin, dest::IO=stdout)
    if isnothing(value) || isempty(value)
        return
    end

    words = split(value)
    width = textwidth - lmargin
    padding = repeat(' ', lmargin)
    
    (w, words) = Iterators.peel(words)

    print(dest, w)
    pos = lmargin + length(w)

    for w in words
        lw = length(w)
        endp = pos + lw + 1

        if (endp <= textwidth)
            print(dest, ' ', w)
            pos = endp
        else
            print(dest, "\n", padding, w)
            pos = lmargin + lw
        end
    end
end

function entry2bib(entry, dest::IO=stdout)
    print(dest, '@', entry["type"], '{', entry["label"])
    lmargin = fieldlen + 5

    for field in fields
        if haskey(entry, field)
            println(dest, ',')
            print(dest, "  ", field, " =")
            print(dest, repeat(' ', fieldlen - length(field)))
            print(dest, '{')
            
            if (field == "author")
                value = join(entry[field], " and ")
            else
                value = entry[field]
            end

            print_val(value, lmargin, dest)
            print(dest, '}')
        end
    end

    println(dest, "\n}")
end

function entry2bib(entry, filename)
    open(filename) do f
        entry2bib(entry, f)
    end
end


"Make entry labels unique."
function unique_labels!(entries)
    labels = Dict{String,Int}()

    for e in entries
        label = e["label"]
        lclabel = lowercase(label)

        if !haskey(labels, lclabel)
            labels[lclabel] = 0
        else
            labels[lclabel] += 1
            new_label = label * "_" * string(labels[lclabel])
            new_lclabel = lowercase(new_label)

            while haskey(labels, new_lclabel)
                labels[lclabel] += 1
                new_label = label * "_" * string(labels[lclabel])
                new_lclabel = lowercase(new_label)
            end

            labels[new_lclabel] = 0
            e["label"] = new_label
        end
    end

    return entries
end

function unique_labels(entries)
    entries = deepcopy(entries)
    unique_labels!(entries)

    return entries
end



"""
Generate BibTeX file from entries or ArXiv search, e.g.

  bibfile(\"au:Massar_S\", "massar_s.bib")
"""
function bibfile(entries, dest::IO; unique_lbls::Bool=false)
    if entries isa String
        entries = arxiv_entries(entries)

        if unique_lbls
            unique_labels!(entries)
        end
    elseif isempty(entries)
        return
    elseif unique_lbls
        entries = unique_labels(entries)
    end

    (e, entries) = Iterators.peel(entries)

    entry2bib(e, dest)

    for e in entries
        println(dest)
        entry2bib(e, dest)
    end
end

function bibfile(entries, filename::String; unique_lbls::Bool=false)
    open(filename, "w") do f
        bibfile(entries, f, unique_lbls=unique_lbls)
    end
end

function bibfile(entries; unique_lbls::Bool=false)
    bibfile(entries, stdout, unique_lbls=unique_lbls)
end
