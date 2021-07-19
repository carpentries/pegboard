# reporters will work without CLI

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

# reporters will work [plain]

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

# reporters will work [ansi]

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

# reporters will work [unicode]

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

# reporters will work [fancy]

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

# duplciate reporting works [plain]

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

# duplciate reporting works [ansi]

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

# duplciate reporting works [unicode]

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

# duplciate reporting works [fancy]

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

