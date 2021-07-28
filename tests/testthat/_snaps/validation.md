# headings reporters will work without CLI

    Code
      expect_false(all(vh$validate_headings()))
    Message <simpleMessage>
      ! The first heading must be level 2 (It is currently level 1).
      ! First level headings are not allowed.
      ! All headings must be sequential.
      ! All headings must be named.
      ! All headings must have unique IDs.
      # Lesson: "Errors in Headings" 
      -# First heading throws an error (must be level 2) (first level heading)
      ---### This heading throws another error  (non-sequential heading jump)
      --## This heading is okay  (duplicated)
      --## This heading is okay  (duplicated)
      ---### This heading is okay 
      --##   (no name)
      --## This last heading is okay 

---

    Code
      expect_equal(sum(loop$validate_headings()), 4L)
    Message <simpleMessage>
      ! All headings must have unique IDs.
      # Lesson: "Looping Over Data Sets" 
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

# links reporters will work without CLI

    Code
      expect_false(all(cats$validate_links()))
    Message <simpleMessage>
      ! Images need alt-text:
      https://placekitten.com/g/102/102 (image-test.md:12)
      https://placekitten.com/g/109/109 (image-test.md:41)

---

    Code
      expect_equal(sum(loop$validate_links()), 3L)
    Message <simpleMessage>
      ! Images need alt-text:
      https://carpentries.org/assets/img/TheCarpentries.svg (14-looping-data-sets.md:195)
      ../no-workie.svg (14-looping-data-sets.md:197)
      ! These files do not exist in the lesson:
              ../no-workie.svg (14-looping-data-sets.md:191)
      ../no-workie.svg (14-looping-data-sets.md:197)

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <simpleMessage>
      ! Link text should be more descriptive than 'link':
            'link' (link-test.md:18)
      'this link' (link-test.md:18)
      ! Links must use HTTPS, not HTTP:
            http://example.com (link-test.md:42)
      ! The following anchors do not exist in the file:
              #bad-fragment (link-test.md:22)
      ! Relative links that are incorrectly formatted:
              [should be a relative link](rel-image) -> [should be a relative link][rel-image] (link-test.md:37)
      ! These files do not exist in the lesson:
              incorrect-link.html (link-test.md:29)

# headings reporters will work [plain]

    Code
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      ! The first heading must be level 2 (It is currently level 1).
      ! First level headings are not allowed.
      ! All headings must be sequential.
      ! All headings must be named.
      ! All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Errors in Headings" 
      +-# First heading throws an error (must be level 2) (first level heading)
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
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      [33m![39m The first heading must be level 2 (It is currently level 1).
      [33m![39m First level headings are not allowed.
      [33m![39m All headings must be sequential.
      [33m![39m All headings must be named.
      [33m![39m All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Errors in Headings" 
      +-# First heading throws an error [7m(must be level 2)[27m [7m(first level heading)[27m
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
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      ! The first heading must be level 2 (It is currently level 1).
      ! First level headings are not allowed.
      ! All headings must be sequential.
      ! All headings must be named.
      ! All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Errors in Headings" 
      ├─# First heading throws an error (must be level 2) (first level heading)
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
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      [33m![39m The first heading must be level 2 (It is currently level 1).
      [33m![39m First level headings are not allowed.
      [33m![39m All headings must be sequential.
      [33m![39m All headings must be named.
      [33m![39m All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Errors in Headings" 
      ├─# First heading throws an error [7m(must be level 2)[27m [7m(first level heading)[27m
      │ ├─### This heading throws another error  [7m(non-sequential heading jump)[27m
      │ ├─## This heading is okay  [7m(duplicated)[27m
      │ ├─## This heading is okay  [7m(duplicated)[27m
      │ │ └─### This heading is okay 
      │ ├─##   [7m(no name)[27m
      │ └─## This last heading is okay 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

# duplicate headings reporting works [plain]

    Code
      expect_equal(sum(loop$validate_headings()), 4L)
    Message <cliMessage>
      ! All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Looping Over Data Sets" 
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

# duplicate headings reporting works [ansi]

    Code
      expect_equal(sum(loop$validate_headings()), 4L)
    Message <cliMessage>
      [33m![39m All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Looping Over Data Sets" 
      +-## Use a for loop to process files given a list of their names. 
      +-## Use glob.glob to find sets of files whose names match a pattern. 
      +-## Use glob and for to process batches of files. 
      +-## Determining Matches 
      +-## Solution  [7m(duplicated)[27m
      +-## Minimum File Size 
      +-## Solution  [7m(duplicated)[27m
      +-## Comparing Data 
      \-## Solution  [7m(duplicated)[27m
        \-### ZNK test links and images 
    Message <cliMessage>
      --------------------------------------------------------------------------------

# duplicate headings reporting works [unicode]

    Code
      expect_equal(sum(loop$validate_headings()), 4L)
    Message <cliMessage>
      ! All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Looping Over Data Sets" 
      ├─## Use a for loop to process files given a list of their names. 
      ├─## Use glob.glob to find sets of files whose names match a pattern. 
      ├─## Use glob and for to process batches of files. 
      ├─## Determining Matches 
      ├─## Solution  (duplicated)
      ├─## Minimum File Size 
      ├─## Solution  (duplicated)
      ├─## Comparing Data 
      └─## Solution  (duplicated)
        └─### ZNK test links and images 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

# duplicate headings reporting works [fancy]

    Code
      expect_equal(sum(loop$validate_headings()), 4L)
    Message <cliMessage>
      [33m![39m All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Looping Over Data Sets" 
      ├─## Use a for loop to process files given a list of their names. 
      ├─## Use glob.glob to find sets of files whose names match a pattern. 
      ├─## Use glob and for to process batches of files. 
      ├─## Determining Matches 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Minimum File Size 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Comparing Data 
      └─## Solution  [7m(duplicated)[27m
        └─### ZNK test links and images 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

# links reporters will work [plain]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      ! Images need alt-text:
      https://placekitten.com/g/102/102 (image-test.md:12)
      https://placekitten.com/g/109/109 (image-test.md:41)

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      ! Link text should be more descriptive than 'link':
      'link' (link-test.md:18)
      'this link' (link-test.md:18)
      ! Links must use HTTPS, not HTTP:
      http://example.com (link-test.md:42)
      ! The following anchors do not exist in the file:
      #bad-fragment (link-test.md:22)
      ! Relative links that are incorrectly formatted:
      [should be a relative link](rel-image) -> [should be a relative link][rel-image] (link-test.md:37)
      ! These files do not exist in the lesson:
      incorrect-link.html (link-test.md:29)

# links reporters will work [ansi]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      [33m![39m Images need alt-text:
      https://placekitten.com/g/102/102 (image-test.md:12)
      https://placekitten.com/g/109/109 (image-test.md:41)

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      [33m![39m Link text should be more descriptive than 'link':
      'link' (link-test.md:18)
      'this link' (link-test.md:18)
      [33m![39m Links must use HTTPS, not HTTP:
      http://example.com (link-test.md:42)
      [33m![39m The following anchors do not exist in the file:
      #bad-fragment (link-test.md:22)
      [33m![39m Relative links that are incorrectly formatted:
      [should be a relative link](rel-image) -> [should be a relative link][rel-image] (link-test.md:37)
      [33m![39m These files do not exist in the lesson:
      incorrect-link.html (link-test.md:29)

# links reporters will work [unicode]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      ! Images need alt-text:
      https://placekitten.com/g/102/102 (image-test.md:12)
      https://placekitten.com/g/109/109 (image-test.md:41)

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      ! Link text should be more descriptive than 'link':
      'link' (link-test.md:18)
      'this link' (link-test.md:18)
      ! Links must use HTTPS, not HTTP:
      http://example.com (link-test.md:42)
      ! The following anchors do not exist in the file:
      #bad-fragment (link-test.md:22)
      ! Relative links that are incorrectly formatted:
      [should be a relative link](rel-image) -> [should be a relative link][rel-image] (link-test.md:37)
      ! These files do not exist in the lesson:
      incorrect-link.html (link-test.md:29)

# links reporters will work [fancy]

    Code
      expect_false(all(cats$validate_links()))
    Message <cliMessage>
      [33m![39m Images need alt-text:
      https://placekitten.com/g/102/102 (image-test.md:12)
      https://placekitten.com/g/109/109 (image-test.md:41)

---

    Code
      expect_equal(sum(link$validate_links()), 2L)
    Message <cliMessage>
      [33m![39m Link text should be more descriptive than 'link':
      'link' (link-test.md:18)
      'this link' (link-test.md:18)
      [33m![39m Links must use HTTPS, not HTTP:
      http://example.com (link-test.md:42)
      [33m![39m The following anchors do not exist in the file:
      #bad-fragment (link-test.md:22)
      [33m![39m Relative links that are incorrectly formatted:
      [should be a relative link](rel-image) -> [should be a relative link][rel-image] (link-test.md:37)
      [33m![39m These files do not exist in the lesson:
      incorrect-link.html (link-test.md:29)

