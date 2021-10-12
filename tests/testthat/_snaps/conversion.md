# Episodes with commonmark-violating liquid relative links can be read

    Code
      cat(tmp$show(), sep = "\n")
    Output
      Head here for [more examples of Icebreakers][icebreakers].
      
      Introduction materials are adapted from [Carnegie Mellon Eberly
      Center Teaching Excellence \& Educational Innovation][credits]
      
      [icebreakers]: {{page.root}}/icebreakers/ "spicebreaker"
      [credits]: https://www.cmu.edu/teaching/designteach/teach/firstday.html
      
      

# Episodes can be converted to use sandpaper

    Code
      cat(e$tail(15), sep = "\n")
    Output
      <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
      
      <img src="../no-workie.svg" alt="books as clubs">
      
      Link to [Home]({{ page.root }}/index.html) and to [shell]({{ site.swc_pages }}/shell-novice)
      
      ![Carpentries logo](https://carpentries.org/assets/img/TheCarpentries.svg)
      
      ![Non-working image](../no-workie.svg)
      
      This text includes a [link that isn't parsed correctly by commonmark]({{ page.root }}{% link)
      index.md %}). The rest of the text should be properly parsed.
      
      {% include links.md %}
      

---

    Code
      cat(e$use_sandpaper(rmd = TRUE)$tail(15), sep = "\n")
    Output
      <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
      
      <img src="no-workie.svg" alt="books as clubs">
      
      Link to [Home](index.html) and to [shell](https://swcarpentry.github.io/shell-novice)
      
      ![](https://carpentries.org/assets/img/TheCarpentries.svg){alt='Carpentries logo'}
      
      ![](no-workie.svg){alt='Non-working image'}
      
      This text includes a [link that isn't parsed correctly by commonmark](index.md)
      . The rest of the text should be properly parsed.
      
      
      

---

    Code
      cat(e$use_sandpaper(rmd = FALSE)$tail(15), sep = "\n")
    Output
      <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
      
      <img src="no-workie.svg" alt="books as clubs">
      
      Link to [Home](index.html) and to [shell](https://swcarpentry.github.io/shell-novice)
      
      ![](https://carpentries.org/assets/img/TheCarpentries.svg){alt='Carpentries logo'}
      
      ![](no-workie.svg){alt='Non-working image'}
      
      This text includes a [link that isn't parsed correctly by commonmark](index.md)
      . The rest of the text should be properly parsed.
      
      
      

