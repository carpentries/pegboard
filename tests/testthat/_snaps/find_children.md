# children are validated along with parents [plain]

    Code
      lnk <- lsn$validate_links()
    Message <cliMessage>
      ! There were errors in 3/3 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [ansi]

    Code
      lnk <- lsn$validate_links()
    Message <cliMessage>
      [33m![39m There were errors in 3/3 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some linked internal files do not exist
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [unicode]

    Code
      lnk <- lsn$validate_links()
    Message <cliMessage>
      ! There were errors in 3/3 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file]: [broken link](this-file-does-not-exist.md)

# children are validated along with parents [fancy]

    Code
      lnk <- lsn$validate_links()
    Message <cliMessage>
      [33m![39m There were errors in 3/3 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some linked internal files do not exist
      
      learners/setup.md:18 [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      learners/setup.md:26 [needs HTTPS]: [Terminal.app](http://example.com/terminal)
      episodes/files/child.md:2 [missing file]: [broken link](this-file-does-not-exist.md)
