# handouts can be created

    Code
      cat(e$handout())
    Output
      # ```{r retained, purl=TRUE}
      echo("this code is retained")
      # ```
      # 
      # ### A challenge
      # 
      # Text text
      # 
      # 1. task
      # 2. task
      # 
      # ```{r challenge}
      v <- rnorm(10)
      the_sum <- 0
      for (i in v) {
        the_sum <- the_sum + i
      }
      the_mean <- the_sum / length(v)
      # ```
      # 
      # How do you simplify this?
      # 
      # ### Smol challenge
      # 
      # A small challenge here with just text

---

    Code
      cat(e$handout(solution = TRUE))
    Output
      # ```{r retained, purl=TRUE}
      echo("this code is retained")
      # ```
      # 
      # ### A challenge
      # 
      # Text text
      # 
      # 1. task
      # 2. task
      # 
      # ```{r challenge}
      v <- rnorm(10)
      the_sum <- 0
      for (i in v) {
        the_sum <- the_sum + i
      }
      the_mean <- the_sum / length(v)
      # ```
      # 
      # How do you simplify this?
      # 
      # :::: solution
      # 
      # You can use the `mean()` function
      # 
      # ```{r}
      mean(rnorm(10))
      # ```
      # 
      # ::::
      # 
      # ### Smol challenge
      # 
      # A small challenge here with just text
      # 
      # :::: solution
      # 
      # ```{r}
      cat("this is the solution")
      # ```
      # 
      # ::::

