# Sandpaper Lessons can be validated [plain]

    Code
      vhead <- snd$validate_headings()

---

    Code
      vlink <- snd$validate_links()
    Message
      ! There were errors in 2/3 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      
      ::warning file=learners/setup.md,line=18:: [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      ::warning file=learners/setup.md,line=26:: [needs HTTPS]: [Terminal.app](http://example.com/terminal)

# Sandpaper Lessons can be validated [ansi]

    Code
      vhead <- snd$validate_headings()

---

    Code
      vlink <- snd$validate_links()
    Message
      [33m![39m There were errors in 2/3 links
      ( ) Links must use HTTPS <https://https.cio.gov/everything/>
      
      ::warning file=learners/setup.md,line=18:: [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      ::warning file=learners/setup.md,line=26:: [needs HTTPS]: [Terminal.app](http://example.com/terminal)

# Sandpaper Lessons can be validated [unicode]

    Code
      vhead <- snd$validate_headings()

---

    Code
      vlink <- snd$validate_links()
    Message
      ! There were errors in 2/3 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      
      ::warning file=learners/setup.md,line=18:: [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      ::warning file=learners/setup.md,line=26:: [needs HTTPS]: [Terminal.app](http://example.com/terminal)

# Sandpaper Lessons can be validated [fancy]

    Code
      vhead <- snd$validate_headings()

---

    Code
      vlink <- snd$validate_links()
    Message
      [33m![39m There were errors in 2/3 links
      ◌ Links must use HTTPS <https://https.cio.gov/everything/>
      
      ::warning file=learners/setup.md,line=18:: [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
      ::warning file=learners/setup.md,line=26:: [needs HTTPS]: [Terminal.app](http://example.com/terminal)

# Sandpaper lessons have getter and summary methods

    Code
      snd$summary(TRUE)
    Output
      # A tibble: 5 x 12
        page      sections headings callouts challenges solutions  code output warning error images links
        <chr>        <int>    <int>    <int>      <int>     <int> <int>  <int>   <int> <int>  <int> <int>
      1 intro.Rmd        6        6        6          1         2     3      0       0     0      0     1
      2 index.md         0        0        0          0         0     0      0       0     0      0     0
      3 a.md             0        0        0          0         0     0      0       0     0      0     0
      4 setup.md         2        2        3          0         2     0      0       0     0      0     2
      5 b.md             0        0        0          0         0     0      0       0     0      0     0

---

    Code
      snd$summary()
    Output
      # A tibble: 1 x 12
        page      sections headings callouts challenges solutions  code output warning error images links
        <chr>        <int>    <int>    <int>      <int>     <int> <int>  <int>   <int> <int>  <int> <int>
      1 intro.Rmd        6        6        6          1         2     3      0       0     0      0     1

# Sandpaper lessons can read in built files

    Code
      snd$summary(TRUE)
    Output
      # A tibble: 10 x 12
         page                sections headings callouts challenges solutions  code output warning error images links
         <chr>                  <int>    <int>    <int>      <int>     <int> <int>  <int>   <int> <int>  <int> <int>
       1 intro.Rmd                  6        6        6          1         2     3      0       0     0      0     1
       2 index.md                   0        0        0          0         0     0      0       0     0      0     0
       3 a.md                       0        0        0          0         0     0      0       0     0      0     0
       4 setup.md                   2        2        3          0         2     0      0       0     0      0     2
       5 b.md                       0        0        0          0         0     0      0       0     0      0     0
       6 site/built/a.md            0        0        0          0         0     0      0       0     0      0     0
       7 site/built/b.md            0        0        0          0         0     0      0       0     0      0     0
       8 site/built/index.md        0        0        0          0         0     0      0       0     0      0     0
       9 site/built/intro.md        6        6        6          1         2     3      1       0     0      1     1
      10 site/built/setup.md        2        2        3          0         2     0      0       0     0      0     0

---

    Code
      snd$summary("built")
    Output
      # A tibble: 5 x 12
        page                sections headings callouts challenges solutions  code output warning error images links
        <chr>                  <int>    <int>    <int>      <int>     <int> <int>  <int>   <int> <int>  <int> <int>
      1 site/built/a.md            0        0        0          0         0     0      0       0     0      0     0
      2 site/built/b.md            0        0        0          0         0     0      0       0     0      0     0
      3 site/built/index.md        0        0        0          0         0     0      0       0     0      0     0
      4 site/built/intro.md        6        6        6          1         2     3      1       0     0      1     1
      5 site/built/setup.md        2        2        3          0         2     0      0       0     0      0     0

# Sandpaper lessons can create handouts

    Code
      cat(snd$handout())
    Output
      ## Using RMarkdown
      
      # ## Challenge 1: Can you do it?
      # 
      # What is the output of this command?
      # Hint: it will be length 1.
      # 
      # ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      # ```

---

    Code
      cat(snd$handout(solution = TRUE))
    Output
      ## Using RMarkdown
      
      # ## Challenge 1: Can you do it?
      # 
      # What is the output of this command?
      # Hint: it will be length 1.
      # 
      # ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      # ```
      # 
      # :::::::::::::::::::::::: solution
      # 
      # ## Output
      # 
      # ```{r, echo=FALSE}
      paste("This", "new", "template", "looks", "good")
      # ```
      # 
      # ::::::::::::::::::::::::::::::::::
      # 
      # ## Challenge 2: how do you nest solutions within challenge blocks?
      # 
      # :::::::::::::::::::::::: solution
      # 
      # You can add a line with at least three colons and a `solution` tag.

---

    Code
      writeLines(readLines(tmp))
    Output
      ## Using RMarkdown
      
      # ## Challenge 1: Can you do it?
      # 
      # What is the output of this command?
      # Hint: it will be length 1.
      # 
      # ```{r, eval=FALSE}
      paste("This", "new", "template", "looks", "good")
      # ```
      # 
      # :::::::::::::::::::::::: solution
      # 
      # ## Output
      # 
      # ```{r, echo=FALSE}
      paste("This", "new", "template", "looks", "good")
      # ```
      # 
      # ::::::::::::::::::::::::::::::::::
      # 
      # ## Challenge 2: how do you nest solutions within challenge blocks?
      # 
      # :::::::::::::::::::::::: solution
      # 
      # You can add a line with at least three colons and a `solution` tag.
      

---

    Code
      parse(tmp)
    Output
      expression(paste("This", "new", "template", "looks", "good"), 
          paste("This", "new", "template", "looks", "good"))

# Lessons can be validated [plain]

    Code
      vhead <- frg$validate_headings()
    Message
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
    Message
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
    Message
      --------------------------------------------------------------------------------
      ! There were errors in 13/37 headings
      ( ) Headings must be unique
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
    Message
      ! There were errors in 4/14 images
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ( ) Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg

# Lessons can be validated [ansi]

    Code
      vhead <- frg$validate_headings()
    Message
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
    Message
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
    Message
      --------------------------------------------------------------------------------
      [33m![39m There were errors in 13/37 headings
      ( ) Headings must be unique
      [3m[34m<https://webaim.org/techniques/semanticstructure/#headings>[39m[23m
      
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
    Message
      [33m![39m There were errors in 4/14 images
      ( ) Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ( ) Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg

# Lessons can be validated [unicode]

    Code
      vhead <- frg$validate_headings()
    Message
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
    Message
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
    Message
      ────────────────────────────────────────────────────────────────────────────────
      ! There were errors in 13/37 headings
      ◌ Headings must be unique
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
    Message
      ! There were errors in 4/14 images
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg

# Lessons can be validated [fancy]

    Code
      vhead <- frg$validate_headings()
    Message
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
    Message
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
    Message
      ────────────────────────────────────────────────────────────────────────────────
      [33m![39m There were errors in 13/37 headings
      ◌ Headings must be unique
      [3m[34m<https://webaim.org/techniques/semanticstructure/#headings>[39m[23m
      
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
    Message
      [33m![39m There were errors in 4/14 images
      ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
      ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
      
      ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
      ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
      ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg

