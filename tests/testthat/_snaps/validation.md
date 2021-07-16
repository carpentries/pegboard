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
      --## This heading is okay 
      --## This heading is okay  (duplicated)
      ---### This heading is okay 
      --##   (no name)
      --## This last heading is okay 

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
      | +-## This heading is okay 
      | +-## This heading is okay 
      | +-##   (no name)
      | \-## This last heading is okay 
      \-## This heading is okay 
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
      | +-## This heading is okay 
      | +-## This heading is okay 
      | +-##   [7m(no name)[27m
      | \-## This last heading is okay 
      \-## This heading is okay 
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
      │ ├─## This heading is okay 
      │ ├─## This heading is okay 
      │ ├─##   (no name)
      │ └─## This last heading is okay 
      └─## This heading is okay 
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
      │ ├─## This heading is okay 
      │ ├─## This heading is okay 
      │ ├─##   [7m(no name)[27m
      │ └─## This last heading is okay 
      └─## This heading is okay 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────

