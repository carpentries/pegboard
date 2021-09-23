# headings reporters will work without CLI

    Code
      res <- vh$validate_headings()
    Message <simpleMessage>
      ! There were errors in 5 headings
      
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
    Message <simpleMessage>
      ! There were errors in 3 headings
      
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

# headings reporters will work on CI

    Code
      res <- vh$validate_headings()
    Message <cliMessage>
      ! There were errors in 5 headings
      
      - First heading must be level 2
      - Level 1 headings are not allowed
      - Headings must be sequential
      - Headings must be named
      - Headings must be unique
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
    Message <cliMessage>
      --------------------------------------------------------------------------------

---

    Code
      res <- loop$validate_headings()
    Message <cliMessage>
      ! There were errors in 3 headings
      
      - Headings must be unique
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
    Message <cliMessage>
      --------------------------------------------------------------------------------

# links reporters will work without CLI

    Code
      expect_false(all(cats$validate_links()))
    Message <simpleMessage>
      ! Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      image-test.md:12	https://placekitten.com/g/102/102 [missing alt text]
      image-test.md:41	https://placekitten.com/g/109/109 [missing alt text]

---

    Code
      expect_equal(sum(loop$validate_links()), 4L)
    Message <simpleMessage>
      ! These files do not exist in the lesson:
      14-looping-data-sets.md:191	../no-workie.svg [missing file]
      14-looping-data-sets.md:197	../no-workie.svg [missing file]
      ! Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      14-looping-data-sets.md:195	https://carpentries.org/assets/img/TheCarpentries.svg [missing alt text]
      14-looping-data-sets.md:197	../no-workie.svg [missing alt text]

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <simpleMessage>
      ! Links must use HTTPS, not HTTP:
      link-test.md:42	http://example.com [HTTP protocol]
      ! The following anchors do not exist in the file:
      link-test.md:22	#bad-fragment [missing anchor]
      ! Relative links that are incorrectly formatted:
      link-test.md:37	[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      ! These files do not exist in the lesson:
      link-test.md:29	incorrect-link.html [missing file]
      ! Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      link-test.md:18	'link' [uninformative]
      link-test.md:18	'this link' [uninformative]
      link-test.md:50	'this' [uninformative]
      link-test.md:51	'link' [uninformative]
      link-test.md:52	'this link' [uninformative]
      link-test.md:53	'a link' [uninformative]
      link-test.md:54	'link to' [uninformative]
      link-test.md:55	'here' [uninformative]
      link-test.md:56	'here for' [uninformative]
      link-test.md:57	'click here for' [uninformative]
      link-test.md:58	'over here for' [uninformative]
      link-test.md:59	'more' [uninformative]
      link-test.md:60	'more about' [uninformative]
      link-test.md:61	'for more about' [uninformative]
      link-test.md:62	'for more info about' [uninformative]
      link-test.md:63	'for more information about' [uninformative]
      link-test.md:64	'read more about' [uninformative]
      link-test.md:65	'read more' [uninformative]
      link-test.md:66	'read on' [uninformative]
      link-test.md:67	'read on about' [uninformative]
      ! Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      link-test.md:68	'a' [length]
      link-test.md:69	'' [length]

# headings reporters will work [plain]

    Code
      res <- vh$validate_headings()
    Message <cliMessage>
      ! There were errors in 5 headings
      
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
    Message <cliMessage>
      --------------------------------------------------------------------------------

# headings reporters will work [ansi]

    Code
      res <- vh$validate_headings()
    Message <cliMessage>
      [33m![39m There were errors in 5 headings
      
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
    Message <cliMessage>
      --------------------------------------------------------------------------------

# headings reporters will work [unicode]

    Code
      res <- vh$validate_headings()
    Message <cliMessage>
      ! There were errors in 5 headings
      
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
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

# headings reporters will work [fancy]

    Code
      res <- vh$validate_headings()
    Message <cliMessage>
      [33m![39m There were errors in 5 headings
      
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
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

# links reporters will work [plain]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      ! Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      image-test.md:12	https://placekitten.com/g/102/102 [missing alt text]
      image-test.md:41	https://placekitten.com/g/109/109 [missing alt text]

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      ! Links must use HTTPS, not HTTP:
      link-test.md:42	http://example.com [HTTP protocol]
      ! The following anchors do not exist in the file:
      link-test.md:22	#bad-fragment [missing anchor]
      ! Relative links that are incorrectly formatted:
      link-test.md:37	[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      ! These files do not exist in the lesson:
      link-test.md:29	incorrect-link.html [missing file]
      ! Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      link-test.md:18	'link' [uninformative]
      link-test.md:18	'this link' [uninformative]
      link-test.md:50	'this' [uninformative]
      link-test.md:51	'link' [uninformative]
      link-test.md:52	'this link' [uninformative]
      link-test.md:53	'a link' [uninformative]
      link-test.md:54	'link to' [uninformative]
      link-test.md:55	'here' [uninformative]
      link-test.md:56	'here for' [uninformative]
      link-test.md:57	'click here for' [uninformative]
      link-test.md:58	'over here for' [uninformative]
      link-test.md:59	'more' [uninformative]
      link-test.md:60	'more about' [uninformative]
      link-test.md:61	'for more about' [uninformative]
      link-test.md:62	'for more info about' [uninformative]
      link-test.md:63	'for more information about' [uninformative]
      link-test.md:64	'read more about' [uninformative]
      link-test.md:65	'read more' [uninformative]
      link-test.md:66	'read on' [uninformative]
      link-test.md:67	'read on about' [uninformative]
      ! Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      link-test.md:68	'a' [length]
      link-test.md:69	'' [length]

# links reporters will work [ansi]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      [33m![39m Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      image-test.md:12	https://placekitten.com/g/102/102 [missing alt text]
      image-test.md:41	https://placekitten.com/g/109/109 [missing alt text]

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      [33m![39m Links must use HTTPS, not HTTP:
      link-test.md:42	http://example.com [HTTP protocol]
      [33m![39m The following anchors do not exist in the file:
      link-test.md:22	#bad-fragment [missing anchor]
      [33m![39m Relative links that are incorrectly formatted:
      link-test.md:37	[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      [33m![39m These files do not exist in the lesson:
      link-test.md:29	incorrect-link.html [missing file]
      [33m![39m Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      link-test.md:18	'link' [uninformative]
      link-test.md:18	'this link' [uninformative]
      link-test.md:50	'this' [uninformative]
      link-test.md:51	'link' [uninformative]
      link-test.md:52	'this link' [uninformative]
      link-test.md:53	'a link' [uninformative]
      link-test.md:54	'link to' [uninformative]
      link-test.md:55	'here' [uninformative]
      link-test.md:56	'here for' [uninformative]
      link-test.md:57	'click here for' [uninformative]
      link-test.md:58	'over here for' [uninformative]
      link-test.md:59	'more' [uninformative]
      link-test.md:60	'more about' [uninformative]
      link-test.md:61	'for more about' [uninformative]
      link-test.md:62	'for more info about' [uninformative]
      link-test.md:63	'for more information about' [uninformative]
      link-test.md:64	'read more about' [uninformative]
      link-test.md:65	'read more' [uninformative]
      link-test.md:66	'read on' [uninformative]
      link-test.md:67	'read on about' [uninformative]
      [33m![39m Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      link-test.md:68	'a' [length]
      link-test.md:69	'' [length]

# links reporters will work [unicode]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      ! Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      image-test.md:12	https://placekitten.com/g/102/102 [missing alt text]
      image-test.md:41	https://placekitten.com/g/109/109 [missing alt text]

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      ! Links must use HTTPS, not HTTP:
      link-test.md:42	http://example.com [HTTP protocol]
      ! The following anchors do not exist in the file:
      link-test.md:22	#bad-fragment [missing anchor]
      ! Relative links that are incorrectly formatted:
      link-test.md:37	[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      ! These files do not exist in the lesson:
      link-test.md:29	incorrect-link.html [missing file]
      ! Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      link-test.md:18	'link' [uninformative]
      link-test.md:18	'this link' [uninformative]
      link-test.md:50	'this' [uninformative]
      link-test.md:51	'link' [uninformative]
      link-test.md:52	'this link' [uninformative]
      link-test.md:53	'a link' [uninformative]
      link-test.md:54	'link to' [uninformative]
      link-test.md:55	'here' [uninformative]
      link-test.md:56	'here for' [uninformative]
      link-test.md:57	'click here for' [uninformative]
      link-test.md:58	'over here for' [uninformative]
      link-test.md:59	'more' [uninformative]
      link-test.md:60	'more about' [uninformative]
      link-test.md:61	'for more about' [uninformative]
      link-test.md:62	'for more info about' [uninformative]
      link-test.md:63	'for more information about' [uninformative]
      link-test.md:64	'read more about' [uninformative]
      link-test.md:65	'read more' [uninformative]
      link-test.md:66	'read on' [uninformative]
      link-test.md:67	'read on about' [uninformative]
      ! Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      link-test.md:68	'a' [length]
      link-test.md:69	'' [length]

# links reporters will work [fancy]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      [33m![39m Images need alt-text:
      <https://webaim.org/techniques/hypertext/link_text#alt_link>
      image-test.md:12	https://placekitten.com/g/102/102 [missing alt text]
      image-test.md:41	https://placekitten.com/g/109/109 [missing alt text]

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      [33m![39m Links must use HTTPS, not HTTP:
      link-test.md:42	http://example.com [HTTP protocol]
      [33m![39m The following anchors do not exist in the file:
      link-test.md:22	#bad-fragment [missing anchor]
      [33m![39m Relative links that are incorrectly formatted:
      link-test.md:37	[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      [33m![39m These files do not exist in the lesson:
      link-test.md:29	incorrect-link.html [missing file]
      [33m![39m Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      link-test.md:18	'link' [uninformative]
      link-test.md:18	'this link' [uninformative]
      link-test.md:50	'this' [uninformative]
      link-test.md:51	'link' [uninformative]
      link-test.md:52	'this link' [uninformative]
      link-test.md:53	'a link' [uninformative]
      link-test.md:54	'link to' [uninformative]
      link-test.md:55	'here' [uninformative]
      link-test.md:56	'here for' [uninformative]
      link-test.md:57	'click here for' [uninformative]
      link-test.md:58	'over here for' [uninformative]
      link-test.md:59	'more' [uninformative]
      link-test.md:60	'more about' [uninformative]
      link-test.md:61	'for more about' [uninformative]
      link-test.md:62	'for more info about' [uninformative]
      link-test.md:63	'for more information about' [uninformative]
      link-test.md:64	'read more about' [uninformative]
      link-test.md:65	'read more' [uninformative]
      link-test.md:66	'read on' [uninformative]
      link-test.md:67	'read on about' [uninformative]
      [33m![39m Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      link-test.md:68	'a' [length]
      link-test.md:69	'' [length]

# links reporters will work on CI

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      ! Links must use HTTPS, not HTTP:
      ::warning file=link-test.md,line=42::http://example.com [HTTP protocol]
      ! The following anchors do not exist in the file:
      ::warning file=link-test.md,line=22::#bad-fragment [missing anchor]
      ! Relative links that are incorrectly formatted:
      ::warning file=link-test.md,line=37::[should be a relative link](rel-image) -> [should be a relative link][rel-image] [format]
      ! These files do not exist in the lesson:
      ::warning file=link-test.md,line=29::incorrect-link.html [missing file]
      ! Avoid uninformative link phrases:
      <https://webaim.org/techniques/hypertext/link_text#uninformative>
      ::warning file=link-test.md,line=18::'link' [uninformative]
      ::warning file=link-test.md,line=18::'this link' [uninformative]
      ::warning file=link-test.md,line=50::'this' [uninformative]
      ::warning file=link-test.md,line=51::'link' [uninformative]
      ::warning file=link-test.md,line=52::'this link' [uninformative]
      ::warning file=link-test.md,line=53::'a link' [uninformative]
      ::warning file=link-test.md,line=54::'link to' [uninformative]
      ::warning file=link-test.md,line=55::'here' [uninformative]
      ::warning file=link-test.md,line=56::'here for' [uninformative]
      ::warning file=link-test.md,line=57::'click here for' [uninformative]
      ::warning file=link-test.md,line=58::'over here for' [uninformative]
      ::warning file=link-test.md,line=59::'more' [uninformative]
      ::warning file=link-test.md,line=60::'more about' [uninformative]
      ::warning file=link-test.md,line=61::'for more about' [uninformative]
      ::warning file=link-test.md,line=62::'for more info about' [uninformative]
      ::warning file=link-test.md,line=63::'for more information about' [uninformative]
      ::warning file=link-test.md,line=64::'read more about' [uninformative]
      ::warning file=link-test.md,line=65::'read more' [uninformative]
      ::warning file=link-test.md,line=66::'read on' [uninformative]
      ::warning file=link-test.md,line=67::'read on about' [uninformative]
      ! Avoid single-letter or missing link text:
      <https://webaim.org/techniques/hypertext/link_text#link_length>
      ::warning file=link-test.md,line=68::'a' [length]
      ::warning file=link-test.md,line=69::'' [length]

