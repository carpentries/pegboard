# Lessons can be validated [plain]

    Code
      frg$validate_headings()
    Message <cliMessage>
      ! All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "For Loops" 
      +-## A for loop executes commands once for each value in a collection. 
      +-## A for loop is made up of a collection, a loop variable, and a body. 
      +-## The first line of the for loop must end with a colon, and the body must be 
      +-## Loop variables can be called anything. 
      +-## The body of a loop can contain many statements. 
      +-## Use range to iterate over a sequence of numbers. 
      +-## The Accumulator pattern turns many values into one. 
      +-## Classifying Errors 
      +-## Solution  (duplicated)
      +-## Tracing Execution 
      +-## Solution  (duplicated)
      +-## Reversing a String 
      +-## Solution  (duplicated)
      +-## Practice Accumulating 
      +-## Solution  (duplicated)
      +-## Solution  (duplicated)
      +-## Solution  (duplicated)
      +-## Solution  (duplicated)
      +-## Cumulative Sum 
      +-## Solution  (duplicated)
      +-## Identifying Variable Name Errors 
      +-## Solution  (duplicated)
      +-## Identifying Item Errors 
      \-## Solution  (duplicated)
    Message <cliMessage>
      --------------------------------------------------------------------------------
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
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Variable Scope" 
      +-## The scope of a variable is the part of a program that can 'see' that variab
      +-## Local and Global Variable Use 
      \-## Reading Error Messages 
    Message <cliMessage>
      --------------------------------------------------------------------------------
    Output
      # A tibble: 5 x 5
        type           `10-lunch.md` `12-for-loops.m~ `14-looping-data-~ `17-scope.md`
        <chr>          <lgl>         <lgl>            <lgl>              <lgl>        
      1 first_heading~ TRUE          TRUE             TRUE               TRUE         
      2 all_are_great~ TRUE          TRUE             TRUE               TRUE         
      3 all_are_seque~ TRUE          TRUE             TRUE               TRUE         
      4 all_have_names TRUE          TRUE             TRUE               TRUE         
      5 all_are_unique TRUE          FALSE            FALSE              TRUE         

---

    Code
      frg$validate_links()
    Message <cliMessage>
      ! Images need alt-text:
      https://carpentries.org/assets/img/TheCarpentries.svg (14-looping-data-sets.md:195)
      ../no-workie.svg (14-looping-data-sets.md:197)
      ! These files do not exist in the lesson:
      ../no-workie.svg (14-looping-data-sets.md:191)
      ../no-workie.svg (14-looping-data-sets.md:197)
    Output
      # A tibble: 5 x 5
        type       `10-lunch.md` `12-for-loops.md` `14-looping-data-set~ `17-scope.md`
        <chr>      <lgl>         <lgl>             <lgl>                 <lgl>        
      1 enforce_h~ TRUE          TRUE              TRUE                  TRUE         
      2 internal_~ TRUE          TRUE              FALSE                 TRUE         
      3 all_reach~ TRUE          TRUE              TRUE                  TRUE         
      4 img_alt_t~ TRUE          TRUE              FALSE                 TRUE         
      5 descripti~ TRUE          TRUE              TRUE                  TRUE         

# Lessons can be validated [ansi]

    Code
      frg$validate_headings()
    Message <cliMessage>
      [33m![39m All headings must have unique IDs.
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "For Loops" 
      +-## A for loop executes commands once for each value in a collection. 
      +-## A for loop is made up of a collection, a loop variable, and a body. 
      +-## The first line of the for loop must end with a colon, and the body must be 
      +-## Loop variables can be called anything. 
      +-## The body of a loop can contain many statements. 
      +-## Use range to iterate over a sequence of numbers. 
      +-## The Accumulator pattern turns many values into one. 
      +-## Classifying Errors 
      +-## Solution  [7m(duplicated)[27m
      +-## Tracing Execution 
      +-## Solution  [7m(duplicated)[27m
      +-## Reversing a String 
      +-## Solution  [7m(duplicated)[27m
      +-## Practice Accumulating 
      +-## Solution  [7m(duplicated)[27m
      +-## Solution  [7m(duplicated)[27m
      +-## Solution  [7m(duplicated)[27m
      +-## Solution  [7m(duplicated)[27m
      +-## Cumulative Sum 
      +-## Solution  [7m(duplicated)[27m
      +-## Identifying Variable Name Errors 
      +-## Solution  [7m(duplicated)[27m
      +-## Identifying Item Errors 
      \-## Solution  [7m(duplicated)[27m
    Message <cliMessage>
      --------------------------------------------------------------------------------
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
      -- Heading structure -----------------------------------------------------------
    Output
      # Lesson: "Variable Scope" 
      +-## The scope of a variable is the part of a program that can 'see' that variab
      +-## Local and Global Variable Use 
      \-## Reading Error Messages 
    Message <cliMessage>
      --------------------------------------------------------------------------------
    Output
      [90m# A tibble: 5 x 5[39m
        type           `10-lunch.md` `12-for-loops.m~ `14-looping-data-~ `17-scope.md`
        [3m[90m<chr>[39m[23m          [3m[90m<lgl>[39m[23m         [3m[90m<lgl>[39m[23m            [3m[90m<lgl>[39m[23m              [3m[90m<lgl>[39m[23m        
      [90m1[39m first_heading~ TRUE          TRUE             TRUE               TRUE         
      [90m2[39m all_are_great~ TRUE          TRUE             TRUE               TRUE         
      [90m3[39m all_are_seque~ TRUE          TRUE             TRUE               TRUE         
      [90m4[39m all_have_names TRUE          TRUE             TRUE               TRUE         
      [90m5[39m all_are_unique TRUE          FALSE            FALSE              TRUE         

---

    Code
      frg$validate_links()
    Message <cliMessage>
      [33m![39m Images need alt-text:
      https://carpentries.org/assets/img/TheCarpentries.svg (14-looping-data-sets.md:195)
      ../no-workie.svg (14-looping-data-sets.md:197)
      [33m![39m These files do not exist in the lesson:
      ../no-workie.svg (14-looping-data-sets.md:191)
      ../no-workie.svg (14-looping-data-sets.md:197)
    Output
      [90m# A tibble: 5 x 5[39m
        type       `10-lunch.md` `12-for-loops.md` `14-looping-data-set~ `17-scope.md`
        [3m[90m<chr>[39m[23m      [3m[90m<lgl>[39m[23m         [3m[90m<lgl>[39m[23m             [3m[90m<lgl>[39m[23m                 [3m[90m<lgl>[39m[23m        
      [90m1[39m enforce_h~ TRUE          TRUE              TRUE                  TRUE         
      [90m2[39m internal_~ TRUE          TRUE              FALSE                 TRUE         
      [90m3[39m all_reach~ TRUE          TRUE              TRUE                  TRUE         
      [90m4[39m img_alt_t~ TRUE          TRUE              FALSE                 TRUE         
      [90m5[39m descripti~ TRUE          TRUE              TRUE                  TRUE         

# Lessons can be validated [unicode]

    Code
      frg$validate_headings()
    Message <cliMessage>
      ! All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "For Loops" 
      ├─## A for loop executes commands once for each value in a collection. 
      ├─## A for loop is made up of a collection, a loop variable, and a body. 
      ├─## The first line of the for loop must end with a colon, and the body must be 
      ├─## Loop variables can be called anything. 
      ├─## The body of a loop can contain many statements. 
      ├─## Use range to iterate over a sequence of numbers. 
      ├─## The Accumulator pattern turns many values into one. 
      ├─## Classifying Errors 
      ├─## Solution  (duplicated)
      ├─## Tracing Execution 
      ├─## Solution  (duplicated)
      ├─## Reversing a String 
      ├─## Solution  (duplicated)
      ├─## Practice Accumulating 
      ├─## Solution  (duplicated)
      ├─## Solution  (duplicated)
      ├─## Solution  (duplicated)
      ├─## Solution  (duplicated)
      ├─## Cumulative Sum 
      ├─## Solution  (duplicated)
      ├─## Identifying Variable Name Errors 
      ├─## Solution  (duplicated)
      ├─## Identifying Item Errors 
      └─## Solution  (duplicated)
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────
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
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Variable Scope" 
      ├─## The scope of a variable is the part of a program that can 'see' that variab
      ├─## Local and Global Variable Use 
      └─## Reading Error Messages 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────
    Output
      # A tibble: 5 × 5
        type           `10-lunch.md` `12-for-loops.m… `14-looping-data-… `17-scope.md`
        <chr>          <lgl>         <lgl>            <lgl>              <lgl>        
      1 first_heading… TRUE          TRUE             TRUE               TRUE         
      2 all_are_great… TRUE          TRUE             TRUE               TRUE         
      3 all_are_seque… TRUE          TRUE             TRUE               TRUE         
      4 all_have_names TRUE          TRUE             TRUE               TRUE         
      5 all_are_unique TRUE          FALSE            FALSE              TRUE         

---

    Code
      frg$validate_links()
    Message <cliMessage>
      ! Images need alt-text:
      https://carpentries.org/assets/img/TheCarpentries.svg (14-looping-data-sets.md:195)
      ../no-workie.svg (14-looping-data-sets.md:197)
      ! These files do not exist in the lesson:
      ../no-workie.svg (14-looping-data-sets.md:191)
      ../no-workie.svg (14-looping-data-sets.md:197)
    Output
      # A tibble: 5 × 5
        type       `10-lunch.md` `12-for-loops.md` `14-looping-data-set… `17-scope.md`
        <chr>      <lgl>         <lgl>             <lgl>                 <lgl>        
      1 enforce_h… TRUE          TRUE              TRUE                  TRUE         
      2 internal_… TRUE          TRUE              FALSE                 TRUE         
      3 all_reach… TRUE          TRUE              TRUE                  TRUE         
      4 img_alt_t… TRUE          TRUE              FALSE                 TRUE         
      5 descripti… TRUE          TRUE              TRUE                  TRUE         

# Lessons can be validated [fancy]

    Code
      frg$validate_headings()
    Message <cliMessage>
      [33m![39m All headings must have unique IDs.
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "For Loops" 
      ├─## A for loop executes commands once for each value in a collection. 
      ├─## A for loop is made up of a collection, a loop variable, and a body. 
      ├─## The first line of the for loop must end with a colon, and the body must be 
      ├─## Loop variables can be called anything. 
      ├─## The body of a loop can contain many statements. 
      ├─## Use range to iterate over a sequence of numbers. 
      ├─## The Accumulator pattern turns many values into one. 
      ├─## Classifying Errors 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Tracing Execution 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Reversing a String 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Practice Accumulating 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Solution  [7m(duplicated)[27m
      ├─## Solution  [7m(duplicated)[27m
      ├─## Solution  [7m(duplicated)[27m
      ├─## Cumulative Sum 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Identifying Variable Name Errors 
      ├─## Solution  [7m(duplicated)[27m
      ├─## Identifying Item Errors 
      └─## Solution  [7m(duplicated)[27m
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────
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
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Lesson: "Variable Scope" 
      ├─## The scope of a variable is the part of a program that can 'see' that variab
      ├─## Local and Global Variable Use 
      └─## Reading Error Messages 
    Message <cliMessage>
      ────────────────────────────────────────────────────────────────────────────────
    Output
      [90m# A tibble: 5 × 5[39m
        type           `10-lunch.md` `12-for-loops.m… `14-looping-data-… `17-scope.md`
        [3m[90m<chr>[39m[23m          [3m[90m<lgl>[39m[23m         [3m[90m<lgl>[39m[23m            [3m[90m<lgl>[39m[23m              [3m[90m<lgl>[39m[23m        
      [90m1[39m first_heading… TRUE          TRUE             TRUE               TRUE         
      [90m2[39m all_are_great… TRUE          TRUE             TRUE               TRUE         
      [90m3[39m all_are_seque… TRUE          TRUE             TRUE               TRUE         
      [90m4[39m all_have_names TRUE          TRUE             TRUE               TRUE         
      [90m5[39m all_are_unique TRUE          FALSE            FALSE              TRUE         

---

    Code
      frg$validate_links()
    Message <cliMessage>
      [33m![39m Images need alt-text:
      https://carpentries.org/assets/img/TheCarpentries.svg (14-looping-data-sets.md:195)
      ../no-workie.svg (14-looping-data-sets.md:197)
      [33m![39m These files do not exist in the lesson:
      ../no-workie.svg (14-looping-data-sets.md:191)
      ../no-workie.svg (14-looping-data-sets.md:197)
    Output
      [90m# A tibble: 5 × 5[39m
        type       `10-lunch.md` `12-for-loops.md` `14-looping-data-set… `17-scope.md`
        [3m[90m<chr>[39m[23m      [3m[90m<lgl>[39m[23m         [3m[90m<lgl>[39m[23m             [3m[90m<lgl>[39m[23m                 [3m[90m<lgl>[39m[23m        
      [90m1[39m enforce_h… TRUE          TRUE              TRUE                  TRUE         
      [90m2[39m internal_… TRUE          TRUE              FALSE                 TRUE         
      [90m3[39m all_reach… TRUE          TRUE              TRUE                  TRUE         
      [90m4[39m img_alt_t… TRUE          TRUE              FALSE                 TRUE         
      [90m5[39m descripti… TRUE          TRUE              TRUE                  TRUE         

# Lessons can be _quietly_ validated

    Code
      frg$validate_headings(verbose = FALSE)
    Output
      # A tibble: 5 x 5
        type           `10-lunch.md` `12-for-loops.m~ `14-looping-data-~ `17-scope.md`
        <chr>          <lgl>         <lgl>            <lgl>              <lgl>        
      1 first_heading~ TRUE          TRUE             TRUE               TRUE         
      2 all_are_great~ TRUE          TRUE             TRUE               TRUE         
      3 all_are_seque~ TRUE          TRUE             TRUE               TRUE         
      4 all_have_names TRUE          TRUE             TRUE               TRUE         
      5 all_are_unique TRUE          FALSE            FALSE              TRUE         

---

    Code
      frg$validate_links(verbose = FALSE)
    Output
      # A tibble: 5 x 5
        type       `10-lunch.md` `12-for-loops.md` `14-looping-data-set~ `17-scope.md`
        <chr>      <lgl>         <lgl>             <lgl>                 <lgl>        
      1 enforce_h~ TRUE          TRUE              TRUE                  TRUE         
      2 internal_~ TRUE          TRUE              FALSE                 TRUE         
      3 all_reach~ TRUE          TRUE              TRUE                  TRUE         
      4 img_alt_t~ TRUE          TRUE              FALSE                 TRUE         
      5 descripti~ TRUE          TRUE              TRUE                  TRUE         

