# The python version used by PyCall must have the following packages installed
# arxiv

using Dates, AnyAscii, PyCall
arxiv = pyimport("arxiv")
urllib = pyimport("urllib")

function arxiv2bib(paper)
    author_list = join([author.name for author in paper.authors]," and ")
    year = string(Dates.year(paper.published))
    citation_key = anyascii(split(paper.authors[1].name," ")[end]*year)
    result = 
        "@article{$citation_key,
            title = {$(paper.title)},
            author = {$author_list},
            year =  {$year},
            eprint = {$(paper.get_short_id())}, 
            archivePrefix = {arXiv},
            primaryClass ={$(paper.categories[1])}\n}"
end

"""
Obtain bibtex string from doi through crossref.org
For journals of the APS family the "pages" field is missing. A simple fix is provided below (see add_pages_bibstr!) using the fact that the last part of the doi correspond to the page value for APS journals.
"""
function doi2bib(doi)
    doi_req = urllib.request.Request("http://dx.doi.org/"*doi)
    doi_req.add_header("Accept", "application/x-bibtex")
    f=urllib.request.urlopen(doi_req)
    f.read()
end

function add_data_bibstr(bibstr,data)
    bibstr=bibstr[1:end-2]*",\n"*data*"\n}"
end

function add_arxiv_bibstr(bibstr,paper)
    arxivdata = "\teprint = {$(paper.get_short_id())},\n\tarchivePrefix = {arXiv},\n\tprimaryClass ={$(paper.categories[1])}"
    add_data_bibstr(bibstr,arxivdata)
end

"Add the pages field if it is missing using the last part of the doi"
function add_pages_bibstr(bibstr,doi)
    if occursin("pages",bibstr)
        return bibstr
    else
        pages = "\tpages = {$(split(doi,".")[end])}"
        add_data_bibstr(bibstr,pages)
    end
end


function search2bib(search) 
    bibstr="";
    for paper in search.results()
        if isnothing(paper.doi)
           bibstr=string(bibstr,arxiv2bib(paper),"\n\n")
        else
            bibstr=string(bibstr,doi2bib(paper.doi))
            bibstr=add_pages_bibstr(bibstr,paper.doi)
            bibstr=add_arxiv_bibstr(bibstr,paper)
            bibstr=string(bibstr,"\n\n")
        end
    end
    return bibstr
end

search = arxiv.Search(query="au:Navascues AND au:vertesi AND bounding",sort_by = arxiv.SortCriterion.SubmittedDate)
bibstr=search2bib(search)
print(bibstr)

# filename="pub_serge.bib"
# file=open(filename,"w")
# write(file,bibstr,"\n\n")
# close(file)
