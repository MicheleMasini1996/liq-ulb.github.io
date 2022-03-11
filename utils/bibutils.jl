using Dates, AnyAscii, PyCall, BibTeX

arxiv = pyimport("arxiv")
urllib = pyimport("urllib")



# Get and parse info from ArXiv.

function strip_version(eprint)
    parts = split(eprint, '/')
    parts[end] = first(split(parts[end], 'v'))

    return join(parts, '/')
end

function arxiv2dict(paper)
    authors = [a.name for a in paper.authors]
    eprint = strip_version(paper.get_short_id())

    return Dict("title" => paper.title,
                "author" => authors,
                "doi" => paper.doi,
                "archivePrefix" => "ar{X}iv",
                "eprint" => eprint,
                "primaryClass" => paper.primary_category,
                "type" => "article")
end

"""
Get information about papers matching an ArXiv search and convert results as
a Julia dictionary.
"""
function arxiv_search(query, sort_by=arxiv.SortCriterion.SubmittedDate)
    search = arxiv.Search(query=query, sort_by=sort_by)

    return (arxiv2dict(p) for p in search.results())
end



# Get and parse info from doi.org

function lookup_doi(doi)
    doi_req = urllib.request.Request("http://doi.org/" * doi)
    doi_req.add_header("Accept", "application/x-bibtex")

    f = urllib.request.urlopen(doi_req)
    result = f.read()
    f.close()

    label, entry = first(parse_bibtex(result)[2])
    entry["label"] = label

    return entry
end



function add_from_doi!(entry)
    doi = entry["doi"]
    
    if isnothing(doi)
        return entry
    else
        entry = merge!(entry, lookup_doi(doi))
        entry["doi"] = doi

        return entry
    end
end



function arxiv_entries(search)
    entries = arxiv_search(search)

    return (add_from_doi!(e) for e in entries)
end
