# LIQ website

Website of the Laboratoire d'Information Quantique. The version here can be
seen at https://liq-ulb.github.io/_site/.

This site was made by forking and adapting the website of Allan Lab as
explained [here](http://www.allanlab.org/aboutwebsite.html).



## Local development

Make sure you have Ruby installed. E.g., on Ubuntu:
```
$ sudo apt-get install ruby-full build-essential zlib1g-dev
```

Add these lines to `.bashrc` in your home folder:
```
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
```

Restart the shell and run:
```
$ gem install jekyll bundler webrick
```

Clone the repository somewhere:
```
$ git clone https://github.com/liq-ulb/liq-ulb.github.io.git
```

Go into the directory and run `bundle install`:
```
$ cd liq-ulb.github.io/
$ bundle install
```
When that's done you can start a local server so you can see what the site
looks like as you make edits to it:
```
$ bundle exec jekyll serve
```
When that is running, open your favourite web browser and visit
http://localhost:4000/_site/ to see your local version of the site.



## Building

Run
```
$ jekyll build
```
inside the project directory to rebuild the site. To generate a version of
the site that will be hosted somewhere other than github, first edit the
lines
```
baseurl: "/_site"
url: "https://liq-ulb.github.io"
```
in `_config.yml` accordingly.
