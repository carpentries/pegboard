# children are validated along with parents [plain]

    Code
      lnk <- lsn$validate_links()
    Message
      ! There were errors in 3/4 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [ansi]

    Code
      lnk <- lsn$validate_links()
    Message
      [33m![39m There were errors in 3/4 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [unicode]

    Code
      lnk <- lsn$validate_links()
    Message
      ! There were errors in 3/4 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [fancy]

    Code
      lnk <- lsn$validate_links()
    Message
      [33m![39m There were errors in 3/4 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# missing children will not be read [plain]

    Code
      lnk <- lsn$validate_links()
    Message
      ! There were errors in 3/4 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# missing children will not be read [ansi]

    Code
      lnk <- lsn$validate_links()
    Message
      [33m![39m There were errors in 3/4 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# missing children will not be read [unicode]

    Code
      lnk <- lsn$validate_links()
    Message
      ! There were errors in 3/4 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

# missing children will not be read [fancy]

    Code
      lnk <- lsn$validate_links()
    Message
      [33m![39m There were errors in 3/4 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file (relative to episodes/)]: [broken link](this-file-does-not-exist.md)

