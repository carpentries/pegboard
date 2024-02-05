# headings reporters will work without CLI

    Code
      res <- vh$validate_headings()
    Message
      ! There were errors in 5/7 headings
      
      - First heading must be level 2
       - Level 1 headings are not allowed
       - Headings must be sequential
       - Headings must be named
       - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      validation-headings.md:5  (must be level 2) (first level heading)
      validation-headings.md:7  (non-sequential heading jump)
      validation-headings.md:9  (duplicated)
      validation-headings.md:11  (duplicated)
      validation-headings.md:18  (no name)
      # Episode: "Errors in Headings" 
      -# First heading throws an error  (must be level 2) (first level heading)
      ---### This heading throws another error  (non-sequential heading jump)
      --## This heading is okay  (duplicated)
      --## This heading is okay  (duplicated)
      ---### This heading is okay 
      --##   (no name)
      --## This last heading is okay 

---

    Code
      res <- loop$validate_headings()
    Message
      ! There were errors in 3/10 headings
      
      - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      _episodes/14-looping-data-sets.md:119  (duplicated)
      _episodes/14-looping-data-sets.md:143  (duplicated)
      _episodes/14-looping-data-sets.md:162  (duplicated)
      # Episode: "Looping Over Data Sets" 
      --## Use a for loop to process files given a list of their names. 
      --## Use glob.glob to find sets of files whose names match a pattern. 
      --## Use glob and for to process batches of files. 
      --## Determining Matches 
      --## Solution  (duplicated)
      --## Minimum File Size 
      --## Solution  (duplicated)
      --## Comparing Data 
      --## Solution  (duplicated)
      ---### ZNK test links and images 

# div reporters will work without CLI

    Code
      dv$validate_divs()
    Message
      ! There were errors in 1/5 fenced divs
      
      - The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      validation-divs.md:26  [unknown div] unknown

# links reporters will work without CLI

    Code
      cats$validate_links()
    Message
      ! There were errors in 2/10 images
      
      - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      image-test.md:12  [image missing alt-text]: https://placekitten.com/g/102/102
      image-test.md:41  [image missing alt-text]: https://placekitten.com/g/109/109

---

    Code
      loop$validate_links()
    Message
      ! There were errors in 4/13 images
      
      - Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
       - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      _episodes/14-looping-data-sets.md:191  [missing file]: [](../no-workie.svg)
      _episodes/14-looping-data-sets.md:195  [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
      _episodes/14-looping-data-sets.md:197  [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
      _episodes/14-looping-data-sets.md:199  [image missing alt-text]: {{ page.root }}/no-workie.svg

---

    Code
      link$validate_links()
    Message
      ! There were errors in 31/45 links
      
      - Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
       - Links must use HTTPS <https://https.cio.gov/everything/>
       - Some link anchors for relative links (e.g. [anchor]: link) are missing
       - Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
       - Some links were incorrectly formatted
       - Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
       - Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      link-test.md:18  [uninformative link text]: [link](#label-2)
      link-test.md:18  [uninformative link text]: [this link](#label-2)
      link-test.md:22  [missing anchor]: [absolutely incorrect](#bad-fragment)
      link-test.md:29  [missing file]: [this link is wrong](incorrect-link.html)
      link-test.md:37  [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      link-test.md:41  [missing file]: [does not exist](files/ohno.txt)
      link-test.md:45  [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      link-test.md:47  [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      link-test.md:48  [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      link-test.md:53  [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      link-test.md:61  [uninformative link text]: [this](https://example.com/link-text#bad)
      link-test.md:62  [uninformative link text]: [link](https://example.com/link-text#bad)
      link-test.md:63  [uninformative link text]: [this link](https://example.com/link-text#bad)
      link-test.md:64  [uninformative link text]: [a link](https://example.com/link-text#bad)
      link-test.md:65  [uninformative link text]: [link to](https://example.com/link-text#bad)
      link-test.md:66  [uninformative link text]: [here](https://example.com/link-text#bad)
      link-test.md:67  [uninformative link text]: [here for](https://example.com/link-text#bad)
      link-test.md:68  [uninformative link text]: [click here for](https://example.com/link-text#bad)
      link-test.md:69  [uninformative link text]: [over here for](https://example.com/link-text#bad)
      link-test.md:70  [uninformative link text]: [more](https://example.com/link-text#bad)
      link-test.md:71  [uninformative link text]: [more about](https://example.com/link-text#bad)
      link-test.md:72  [uninformative link text]: [for more about](https://example.com/link-text#bad)
      link-test.md:73  [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      link-test.md:74  [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      link-test.md:75  [uninformative link text]: [read more about](https://example.com/link-text#bad)
      link-test.md:76  [uninformative link text]: [read more](https://example.com/link-text#bad)
      link-test.md:77  [uninformative link text]: [read on](https://example.com/link-text#bad)
      link-test.md:78  [uninformative link text]: [read on about](https://example.com/link-text#bad)
      link-test.md:79  [link text too short]: [a](https://example.com/link-text#bad)
      link-test.md:80  [link text too short]: [](https://example.com/link-text#bad)
      link-test.md:93  [missing anchor]: [missing anchor pointing to float](#floaty)

# headings reporters will work [plain]

    Code
      res <- vh$validate_headings()
    Message
      ! There were errors in 5/7 headings
      ( ) First heading must be level 2
      ( ) Level 1 headings are not allowed
      ( ) Headings must be sequential
      ( ) Headings must be named
      ( ) Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      validation-headings.md:5 (must be level 2) (first level heading)
      validation-headings.md:7 (non-sequential heading jump)
      validation-headings.md:9 (duplicated)
      validation-headings.md:11 (duplicated)
      validation-headings.md:18 (no name)
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "Errors in Headings" 
      +-# First heading throws an error  (must be level 2) (first level heading)
      | +-### This heading throws another error  (non-sequential heading jump)
      | +-## This heading is okay  (duplicated)
      | +-## This heading is okay  (duplicated)
      | | \-### This heading is okay 
      | +-##   (no name)
      | \-## This last heading is okay 
    Message
      --------------------------------------------------------------------------------

# headings reporters will work [ansi]

    Code
      res <- vh$validate_headings()
    Message
      [33m![39m There were errors in 5/7 headings
      ( ) First heading must be level 2
      ( ) Level 1 headings are not allowed
      ( ) Headings must be sequential
      ( ) Headings must be named
      ( ) Headings must be unique
      [3m[34m<https://webaim.org/techniques/semanticstructure/#headings>[39m[23m
      
      validation-headings.md:5 (must be level 2) (first level heading)
      validation-headings.md:7 (non-sequential heading jump)
      validation-headings.md:9 (duplicated)
      validation-headings.md:11 (duplicated)
      validation-headings.md:18 (no name)
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "Errors in Headings" 
      +-# First heading throws an error  [7m(must be level 2)[27m [7m(first level heading)[27m
      | +-### This heading throws another error  [7m(non-sequential heading jump)[27m
      | +-## This heading is okay  [7m(duplicated)[27m
      | +-## This heading is okay  [7m(duplicated)[27m
      | | \-### This heading is okay 
      | +-##   [7m(no name)[27m
      | \-## This last heading is okay 
    Message
      --------------------------------------------------------------------------------

# headings reporters will work [unicode]

    Code
      res <- vh$validate_headings()
    Message
      ! There were errors in 5/7 headings
      ◌ First heading must be level 2
      ◌ Level 1 headings are not allowed
      ◌ Headings must be sequential
      ◌ Headings must be named
      ◌ Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      validation-headings.md:5 (must be level 2) (first level heading)
      validation-headings.md:7 (non-sequential heading jump)
      validation-headings.md:9 (duplicated)
      validation-headings.md:11 (duplicated)
      validation-headings.md:18 (no name)
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "Errors in Headings" 
      ├─# First heading throws an error  (must be level 2) (first level heading)
      │ ├─### This heading throws another error  (non-sequential heading jump)
      │ ├─## This heading is okay  (duplicated)
      │ ├─## This heading is okay  (duplicated)
      │ │ └─### This heading is okay 
      │ ├─##   (no name)
      │ └─## This last heading is okay 
    Message
      ────────────────────────────────────────────────────────────────────────────────

# headings reporters will work [fancy]

    Code
      res <- vh$validate_headings()
    Message
      [33m![39m There were errors in 5/7 headings
      ◌ First heading must be level 2
      ◌ Level 1 headings are not allowed
      ◌ Headings must be sequential
      ◌ Headings must be named
      ◌ Headings must be unique
      [3m[34m<https://webaim.org/techniques/semanticstructure/#headings>[39m[23m
      
      validation-headings.md:5 (must be level 2) (first level heading)
      validation-headings.md:7 (non-sequential heading jump)
      validation-headings.md:9 (duplicated)
      validation-headings.md:11 (duplicated)
      validation-headings.md:18 (no name)
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "Errors in Headings" 
      ├─# First heading throws an error  [7m(must be level 2)[27m [7m(first level heading)[27m
      │ ├─### This heading throws another error  [7m(non-sequential heading jump)[27m
      │ ├─## This heading is okay  [7m(duplicated)[27m
      │ ├─## This heading is okay  [7m(duplicated)[27m
      │ │ └─### This heading is okay 
      │ ├─##   [7m(no name)[27m
      │ └─## This last heading is okay 
    Message
      ────────────────────────────────────────────────────────────────────────────────

# links reporters will work [plain]

    Code
      cats$validate_links()
    Message
      ! There were errors in 2/10 images
      ( ) Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      image-test.md:12 [image missing alt-text]: https://placekitten.com/g/102/102
      image-test.md:41 [image missing alt-text]: https://placekitten.com/g/109/109

---

    Code
      link$validate_links()
    Message
      ! There were errors in 31/45 links
      ( ) Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some link anchors for relative links (e.g. [anchor]: link) are missing
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ( ) Some links were incorrectly formatted
      ( ) Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ( ) Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      link-test.md:18 [uninformative link text]: [link](#label-2)
      link-test.md:18 [uninformative link text]: [this link](#label-2)
      link-test.md:22 [missing anchor]: [absolutely incorrect](#bad-fragment)
      link-test.md:29 [missing file]: [this link is wrong](incorrect-link.html)
      link-test.md:37 [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      link-test.md:41 [missing file]: [does not exist](files/ohno.txt)
      link-test.md:45 [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      link-test.md:47 [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      link-test.md:48 [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      link-test.md:53 [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      link-test.md:61 [uninformative link text]: [this](https://example.com/link-text#bad)
      link-test.md:62 [uninformative link text]: [link](https://example.com/link-text#bad)
      link-test.md:63 [uninformative link text]: [this link](https://example.com/link-text#bad)
      link-test.md:64 [uninformative link text]: [a link](https://example.com/link-text#bad)
      link-test.md:65 [uninformative link text]: [link to](https://example.com/link-text#bad)
      link-test.md:66 [uninformative link text]: [here](https://example.com/link-text#bad)
      link-test.md:67 [uninformative link text]: [here for](https://example.com/link-text#bad)
      link-test.md:68 [uninformative link text]: [click here for](https://example.com/link-text#bad)
      link-test.md:69 [uninformative link text]: [over here for](https://example.com/link-text#bad)
      link-test.md:70 [uninformative link text]: [more](https://example.com/link-text#bad)
      link-test.md:71 [uninformative link text]: [more about](https://example.com/link-text#bad)
      link-test.md:72 [uninformative link text]: [for more about](https://example.com/link-text#bad)
      link-test.md:73 [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      link-test.md:74 [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      link-test.md:75 [uninformative link text]: [read more about](https://example.com/link-text#bad)
      link-test.md:76 [uninformative link text]: [read more](https://example.com/link-text#bad)
      link-test.md:77 [uninformative link text]: [read on](https://example.com/link-text#bad)
      link-test.md:78 [uninformative link text]: [read on about](https://example.com/link-text#bad)
      link-test.md:79 [link text too short]: [a](https://example.com/link-text#bad)
      link-test.md:80 [link text too short]: [](https://example.com/link-text#bad)
      link-test.md:93 [missing anchor]: [missing anchor pointing to float](#floaty)

# links reporters will work [ansi]

    Code
      cats$validate_links()
    Message
      [33m![39m There were errors in 2/10 images
      ( ) Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      image-test.md:12 [image missing alt-text]: https://placekitten.com/g/102/102
      image-test.md:41 [image missing alt-text]: https://placekitten.com/g/109/109

---

    Code
      link$validate_links()
    Message
      [33m![39m There were errors in 31/45 links
      ( ) Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some link anchors for relative links (e.g. [anchor]: link) are missing
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ( ) Some links were incorrectly formatted
      ( ) Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ( ) Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      link-test.md:18 [uninformative link text]: [link](#label-2)
      link-test.md:18 [uninformative link text]: [this link](#label-2)
      link-test.md:22 [missing anchor]: [absolutely incorrect](#bad-fragment)
      link-test.md:29 [missing file]: [this link is wrong](incorrect-link.html)
      link-test.md:37 [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      link-test.md:41 [missing file]: [does not exist](files/ohno.txt)
      link-test.md:45 [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      link-test.md:47 [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      link-test.md:48 [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      link-test.md:53 [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      link-test.md:61 [uninformative link text]: [this](https://example.com/link-text#bad)
      link-test.md:62 [uninformative link text]: [link](https://example.com/link-text#bad)
      link-test.md:63 [uninformative link text]: [this link](https://example.com/link-text#bad)
      link-test.md:64 [uninformative link text]: [a link](https://example.com/link-text#bad)
      link-test.md:65 [uninformative link text]: [link to](https://example.com/link-text#bad)
      link-test.md:66 [uninformative link text]: [here](https://example.com/link-text#bad)
      link-test.md:67 [uninformative link text]: [here for](https://example.com/link-text#bad)
      link-test.md:68 [uninformative link text]: [click here for](https://example.com/link-text#bad)
      link-test.md:69 [uninformative link text]: [over here for](https://example.com/link-text#bad)
      link-test.md:70 [uninformative link text]: [more](https://example.com/link-text#bad)
      link-test.md:71 [uninformative link text]: [more about](https://example.com/link-text#bad)
      link-test.md:72 [uninformative link text]: [for more about](https://example.com/link-text#bad)
      link-test.md:73 [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      link-test.md:74 [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      link-test.md:75 [uninformative link text]: [read more about](https://example.com/link-text#bad)
      link-test.md:76 [uninformative link text]: [read more](https://example.com/link-text#bad)
      link-test.md:77 [uninformative link text]: [read on](https://example.com/link-text#bad)
      link-test.md:78 [uninformative link text]: [read on about](https://example.com/link-text#bad)
      link-test.md:79 [link text too short]: [a](https://example.com/link-text#bad)
      link-test.md:80 [link text too short]: [](https://example.com/link-text#bad)
      link-test.md:93 [missing anchor]: [missing anchor pointing to float](#floaty)

# links reporters will work [unicode]

    Code
      cats$validate_links()
    Message
      ! There were errors in 2/10 images
      ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      image-test.md:12 [image missing alt-text]: https://placekitten.com/g/102/102
      image-test.md:41 [image missing alt-text]: https://placekitten.com/g/109/109

---

    Code
      link$validate_links()
    Message
      ! There were errors in 31/45 links
      ◌ Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some link anchors for relative links (e.g. [anchor]: link) are missing
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ◌ Some links were incorrectly formatted
      ◌ Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ◌ Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      link-test.md:18 [uninformative link text]: [link](#label-2)
      link-test.md:18 [uninformative link text]: [this link](#label-2)
      link-test.md:22 [missing anchor]: [absolutely incorrect](#bad-fragment)
      link-test.md:29 [missing file]: [this link is wrong](incorrect-link.html)
      link-test.md:37 [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      link-test.md:41 [missing file]: [does not exist](files/ohno.txt)
      link-test.md:45 [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      link-test.md:47 [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      link-test.md:48 [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      link-test.md:53 [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      link-test.md:61 [uninformative link text]: [this](https://example.com/link-text#bad)
      link-test.md:62 [uninformative link text]: [link](https://example.com/link-text#bad)
      link-test.md:63 [uninformative link text]: [this link](https://example.com/link-text#bad)
      link-test.md:64 [uninformative link text]: [a link](https://example.com/link-text#bad)
      link-test.md:65 [uninformative link text]: [link to](https://example.com/link-text#bad)
      link-test.md:66 [uninformative link text]: [here](https://example.com/link-text#bad)
      link-test.md:67 [uninformative link text]: [here for](https://example.com/link-text#bad)
      link-test.md:68 [uninformative link text]: [click here for](https://example.com/link-text#bad)
      link-test.md:69 [uninformative link text]: [over here for](https://example.com/link-text#bad)
      link-test.md:70 [uninformative link text]: [more](https://example.com/link-text#bad)
      link-test.md:71 [uninformative link text]: [more about](https://example.com/link-text#bad)
      link-test.md:72 [uninformative link text]: [for more about](https://example.com/link-text#bad)
      link-test.md:73 [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      link-test.md:74 [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      link-test.md:75 [uninformative link text]: [read more about](https://example.com/link-text#bad)
      link-test.md:76 [uninformative link text]: [read more](https://example.com/link-text#bad)
      link-test.md:77 [uninformative link text]: [read on](https://example.com/link-text#bad)
      link-test.md:78 [uninformative link text]: [read on about](https://example.com/link-text#bad)
      link-test.md:79 [link text too short]: [a](https://example.com/link-text#bad)
      link-test.md:80 [link text too short]: [](https://example.com/link-text#bad)
      link-test.md:93 [missing anchor]: [missing anchor pointing to float](#floaty)

# links reporters will work [fancy]

    Code
      cats$validate_links()
    Message
      [33m![39m There were errors in 2/10 images
      ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      image-test.md:12 [image missing alt-text]: https://placekitten.com/g/102/102
      image-test.md:41 [image missing alt-text]: https://placekitten.com/g/109/109

---

    Code
      link$validate_links()
    Message
      [33m![39m There were errors in 31/45 links
      ◌ Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      ◌ Some link anchors for relative links (e.g. [anchor]: link) are missing
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ◌ Some links were incorrectly formatted
      ◌ Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ◌ Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      link-test.md:18 [uninformative link text]: [link](#label-2)
      link-test.md:18 [uninformative link text]: [this link](#label-2)
      link-test.md:22 [missing anchor]: [absolutely incorrect](#bad-fragment)
      link-test.md:29 [missing file]: [this link is wrong](incorrect-link.html)
      link-test.md:37 [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      link-test.md:41 [missing file]: [does not exist](files/ohno.txt)
      link-test.md:45 [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      link-test.md:47 [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      link-test.md:48 [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      link-test.md:53 [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      link-test.md:61 [uninformative link text]: [this](https://example.com/link-text#bad)
      link-test.md:62 [uninformative link text]: [link](https://example.com/link-text#bad)
      link-test.md:63 [uninformative link text]: [this link](https://example.com/link-text#bad)
      link-test.md:64 [uninformative link text]: [a link](https://example.com/link-text#bad)
      link-test.md:65 [uninformative link text]: [link to](https://example.com/link-text#bad)
      link-test.md:66 [uninformative link text]: [here](https://example.com/link-text#bad)
      link-test.md:67 [uninformative link text]: [here for](https://example.com/link-text#bad)
      link-test.md:68 [uninformative link text]: [click here for](https://example.com/link-text#bad)
      link-test.md:69 [uninformative link text]: [over here for](https://example.com/link-text#bad)
      link-test.md:70 [uninformative link text]: [more](https://example.com/link-text#bad)
      link-test.md:71 [uninformative link text]: [more about](https://example.com/link-text#bad)
      link-test.md:72 [uninformative link text]: [for more about](https://example.com/link-text#bad)
      link-test.md:73 [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      link-test.md:74 [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      link-test.md:75 [uninformative link text]: [read more about](https://example.com/link-text#bad)
      link-test.md:76 [uninformative link text]: [read more](https://example.com/link-text#bad)
      link-test.md:77 [uninformative link text]: [read on](https://example.com/link-text#bad)
      link-test.md:78 [uninformative link text]: [read on about](https://example.com/link-text#bad)
      link-test.md:79 [link text too short]: [a](https://example.com/link-text#bad)
      link-test.md:80 [link text too short]: [](https://example.com/link-text#bad)
      link-test.md:93 [missing anchor]: [missing anchor pointing to float](#floaty)

# div reporters will work [plain]

    Code
      dv$validate_divs()
    Message
      ! There were errors in 1/5 fenced divs
      ( ) The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      validation-divs.md:26 [unknown div] unknown

# div reporters will work [ansi]

    Code
      dv$validate_divs()
    Message
      [33m![39m There were errors in 1/5 fenced divs
      ( ) The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      validation-divs.md:26 [unknown div] unknown

# div reporters will work [unicode]

    Code
      dv$validate_divs()
    Message
      ! There were errors in 1/5 fenced divs
      ◌ The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      validation-divs.md:26 [unknown div] unknown

# div reporters will work [fancy]

    Code
      dv$validate_divs()
    Message
      [33m![39m There were errors in 1/5 fenced divs
      ◌ The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      validation-divs.md:26 [unknown div] unknown

# headings reporters will work on CI

    Code
      res <- vh$validate_headings()
    Message
      ! There were errors in 5/7 headings
      ( ) First heading must be level 2
      ( ) Level 1 headings are not allowed
      ( ) Headings must be sequential
      ( ) Headings must be named
      ( ) Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=validation-headings.md,line=5:: (must be level 2) (first level heading)
      ::warning file=validation-headings.md,line=7:: (non-sequential heading jump)
      ::warning file=validation-headings.md,line=9:: (duplicated)
      ::warning file=validation-headings.md,line=11:: (duplicated)
      ::warning file=validation-headings.md,line=18:: (no name)
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "Errors in Headings" 
      +-# First heading throws an error  (must be level 2) (first level heading)
      | +-### This heading throws another error  (non-sequential heading jump)
      | +-## This heading is okay  (duplicated)
      | +-## This heading is okay  (duplicated)
      | | \-### This heading is okay 
      | +-##   (no name)
      | \-## This last heading is okay 
    Message
      --------------------------------------------------------------------------------

---

    Code
      res <- loop$validate_headings()
    Message
      ! There were errors in 3/10 headings
      ( ) Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "Looping Over Data Sets" 
      +-## Use a for loop to process files given a list of their names. 
      +-## Use glob.glob to find sets of files whose names match a pattern. 
      +-## Use glob and for to process batches of files. 
      +-## Determining Matches 
      +-## Solution  (duplicated)
      +-## Minimum File Size 
      +-## Solution  (duplicated)
      +-## Comparing Data 
      \-## Solution  (duplicated)
        \-### ZNK test links and images 
    Message
      --------------------------------------------------------------------------------

# links reporters will work on CI

    Code
      link$validate_links()
    Message
      ! There were errors in 31/45 links
      ( ) Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      ( ) Some link anchors for relative links (e.g. [anchor]: link) are missing
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ( ) Some links were incorrectly formatted
      ( ) Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ( ) Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
      
      ::warning file=link-test.md,line=18:: [uninformative link text]: [link](#label-2)
      ::warning file=link-test.md,line=18:: [uninformative link text]: [this link](#label-2)
      ::warning file=link-test.md,line=22:: [missing anchor]: [absolutely incorrect](#bad-fragment)
      ::warning file=link-test.md,line=29:: [missing file]: [this link is wrong](incorrect-link.html)
      ::warning file=link-test.md,line=37:: [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
      ::warning file=link-test.md,line=41:: [missing file]: [does not exist](files/ohno.txt)
      ::warning file=link-test.md,line=45:: [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
      ::warning file=link-test.md,line=47:: [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
      ::warning file=link-test.md,line=48:: [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
      ::warning file=link-test.md,line=53:: [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
      ::warning file=link-test.md,line=61:: [uninformative link text]: [this](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=62:: [uninformative link text]: [link](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=63:: [uninformative link text]: [this link](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=64:: [uninformative link text]: [a link](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=65:: [uninformative link text]: [link to](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=66:: [uninformative link text]: [here](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=67:: [uninformative link text]: [here for](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=68:: [uninformative link text]: [click here for](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=69:: [uninformative link text]: [over here for](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=70:: [uninformative link text]: [more](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=71:: [uninformative link text]: [more about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=72:: [uninformative link text]: [for more about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=73:: [uninformative link text]: [for more info about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=74:: [uninformative link text]: [for more information about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=75:: [uninformative link text]: [read more about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=76:: [uninformative link text]: [read more](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=77:: [uninformative link text]: [read on](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=78:: [uninformative link text]: [read on about](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=79:: [link text too short]: [a](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=80:: [link text too short]: [](https://example.com/link-text#bad)
      ::warning file=link-test.md,line=93:: [missing anchor]: [missing anchor pointing to float](#floaty)

# div reporters will work on CI

    Code
      dv$validate_divs()
    Message
      ! There were errors in 1/5 fenced divs
      ( ) The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab
      
      ::warning file=validation-divs.md,line=26:: [unknown div] unknown

