# Sandpaper lessons can create handouts

    Code
      cat(snd$handout())
    Output
      ## Using RMarkdown
      
      ## Challenge 1: Can you do it?
      
      What is the output of this command?
      
      ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      ```

---

    Code
      cat(snd$handout(solution = TRUE))
    Output
      ## Using RMarkdown
      
      ## Challenge 1: Can you do it?
      
      What is the output of this command?
      
      ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      ```
      
      :::::::::::::::::::::::: solution
      
      ## Output
      
      ```{r, echo=FALSE}
      paste("This", "new", "template", "looks", "good")
      ```
      
      ::::::::::::::::::::::::::::::::::
      
      ## Challenge 2: how do you nest solutions within challenge blocks?
      
      :::::::::::::::::::::::: solution
      
      You can add a line with at least three colons and a `solution` tag.

---

    Code
      cat(tinkr::yarn$new(tmp)$show(), sep = "\n")
    Output
      ## Using RMarkdown
      
      ## Challenge 1: Can you do it?
      
      What is the output of this command?
      
      ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      ```
      
      :::::::::::::::::::::::: solution
      
      ## Output
      
      ```{r, echo=FALSE}
      paste("This", "new", "template", "looks", "good")
      ```
      
      ::::::::::::::::::::::::::::::::::
      
      ## Challenge 2: how do you nest solutions within challenge blocks?
      
      :::::::::::::::::::::::: solution
      
      You can add a line with at least three colons and a `solution` tag.
      

# Lessons can be validated [plain]

    Code
      vhead <- frg$validate_headings()
    Message <cliMessage>
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "For Loops" 
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
      ! There were errors in 13/37 headings
      
      - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)

---

    Code
      vlink <- frg$validate_links()
    Message <cliMessage>
      ! There were errors in 3/13 links
      
      - Some linked internal files do not exist
      - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file] ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file] ../no-workie.svg [image missing alt-text]

# Lessons can be validated [ansi]

    Code
      vhead <- frg$validate_headings()
    Message <cliMessage>
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "For Loops" 
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
      -- Heading structure -----------------------------------------------------------
    Output
      # Episode: "Looping Over Data Sets" 
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
      [33m![39m There were errors in 13/37 headings
      
      - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)

---

    Code
      vlink <- frg$validate_links()
    Message <cliMessage>
      [33m![39m There were errors in 3/13 links
      
      - Some linked internal files do not exist
      - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file] ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file] ../no-workie.svg [image missing alt-text]

# Lessons can be validated [unicode]

    Code
      vhead <- frg$validate_headings()
    Message <cliMessage>
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "For Loops" 
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
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "Looping Over Data Sets" 
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
      ! There were errors in 13/37 headings
      
      - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)

---

    Code
      vlink <- frg$validate_links()
    Message <cliMessage>
      ! There were errors in 3/13 links
      
      - Some linked internal files do not exist
      - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file] ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file] ../no-workie.svg [image missing alt-text]

# Lessons can be validated [fancy]

    Code
      vhead <- frg$validate_headings()
    Message <cliMessage>
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "For Loops" 
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
      ── Heading structure ───────────────────────────────────────────────────────────
    Output
      # Episode: "Looping Over Data Sets" 
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
      [33m![39m There were errors in 13/37 headings
      
      - Headings must be unique
      <https://webaim.org/techniques/semanticstructure/#headings>
      
      ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
      ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
      ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)

---

    Code
      vlink <- frg$validate_links()
    Message <cliMessage>
      [33m![39m There were errors in 3/13 links
      
      - Some linked internal files do not exist
      - Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file] ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file] ../no-workie.svg [image missing alt-text]
