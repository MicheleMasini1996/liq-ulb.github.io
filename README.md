# LIQ website

Website of the
[Laboratoire d'Information Quantique](https://liq.ulb.ac.be/).

This site was made by forking and adapting the website of Allan Lab as
explained [here](http://www.allanlab.org/aboutwebsite.html). The layout of
the members page is based on the team page of
[Quantum Group @ UGhent](https://www.quantumghent.com/).



## Structure

### Publications

Publications are classified into the topics listed in the
`_data/pubtopics.yml` file depending on how they are tagged in the Bibtex
entries in the `_bibliography/` folder.

The following page shows untagged papers, if there are any:
https://liq.ulb.ac.be/pubs_untagged/.

The repository folder `utils/` contains code that can help with generating
bibentries. To be able to use `bibutils.jl`, you need to install `AnyAscii`
and `PyCall` in Julia and `arxiv` for Python (e.g. with `pip install --user
arxiv`).

In `bibutils.jl`, the main functions you're likely to want to use are
`bibfile()`and possibly `arxiv_entries()`. The former prints BibTeX entries
for ArXiv papers matching a given search string, with additional information
gained from the preprints' DOIs for those that have them. Example:
```julia
julia> include("bibutils.jl");

julia> bibfile("0803.4290")
@article{Navascues_2008,
  title =        {A convergent hierarchy of semidefinite programs
                  characterizing the set of quantum correlations},
  author =       {Navascués, Miguel and Pironio, Stefano and Acín, Antonio},
  journal =      {New Journal of Physics},
  publisher =    {IOP Publishing},
  volume =       {10},
  number =       {7},
  pages =        {073013},
  year =         {2008},
  month =        {Jul},
  doi =          {10.1088/1367-2630/10/7/073013},
  issn =         {1367-2630},
  archivePrefix ={ar{X}iv},
  eprint =       {0803.4290},
  primaryClass = {quant-ph}
}

julia> bibfile("0803.4290", "filename.bib")     # Write same output as above
                                                # in file "filename.bib".
```
In this case there is, unsurprisingly, only one entry because the search
string is the ArXiv ID of a specific preprint.

The function `arxiv_entries()` looks up and returns the metainformation about
preprints (in the form of an array of dictionaries) without printing it. The
output of this function can be passed to `bibfile()` to then generate the
BibTeX entries. In other words, you can get the metainformation about
preprints and print it in two separate steps like this:
```julia
entries = arxiv_entries("0803.4290")
bibfile(entries, "filename.bib")
```



## Development and deployment

### Local development

Make sure you have Ruby installed. E.g., on Ubuntu:
```bash
$ sudo apt-get install ruby-full build-essential zlib1g-dev
```

Add these lines to `.bashrc` in your home folder:
```bash
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
```

Restart the shell and run:
```bash
$ gem install jekyll bundler webrick
```

Clone the repository somewhere:
```bash
$ git clone https://github.com/liq-ulb/liq-ulb.github.io.git
```

Go into the directory and run `bundle install`:
```bash
$ cd liq-ulb.github.io/
$ bundle install
```
When that's done you can start a local server so you can see what the site
looks like as you make edits to it:
```
$ bundle exec jekyll serve
```
When that is running, open your favourite web browser and visit
http://localhost:4000/ to see your local version of the site.



### Building

Run
```bash
$ jekyll build
```
to (re)build the site locally. This will put the site in the `_site/` folder.



### Deploying

There's a Python script `deploy.py` included in the project directory that
automates the task of updating the LIQ website on the ULB server. It depends
on a package `pysftp` which you will probably have to install the first time
you want to use it:
```bash
$ pip install pysftp
```

If you've never logged into the server where the website is hosted before
from the computer you are using, log in to the host using sftp and exit once
to add it to your local list of SSH hosts:
```bash
sftp [user]@[host]
```
using your username and the destination hostname in place of `[user]` and
`[host]`, confirm that you want to continue connecting if/when asked, then
press ctrl-D to exit.

To update the website run:
```bash
$ ./deploy.py [user]@[host]
```
and give your password when asked. This will clear the contents
of the folder `public_html/` on the remote host and then copy the contents of
`_site/` on your computer into `public_html/` on the remote host.

If you get an error message to do with SSH and `No hostkey for host [host]
found` then log in directly with sftp and log out once as explained
above.
