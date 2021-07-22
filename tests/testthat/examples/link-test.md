---
title: Link Tests
---

## Internal links {#internal}

### :crystal_ball: Heading with Emoji

### Heading with long name that has a label {#label-1}

### Another heading with a long name that has a label {#label-2}

### Heading with a class, but no label {.challenge}

### Heading with class and a label {.solution #label-3}

This is a [link to the Heading with Emoji](#heading-with-emoji) and a [link to 
label 1](#label-1) and a [link](#label-2) and [this link](#label-2).

This link goes to [the heading with class and a label](#label-3).

This link is [absolutely incorrect](#bad-fragment)

This [relative link goes to label 1][rel-label-1]

## Cross-Lesson links {#cross-lesson}

This [link will go to the image test](image-test.html), but [this link is 
wrong](incorrect-link.html)

[This link also goes to image test](image-test)
[This link also goes to image test, but with a slash](image-test/), though this
may not work for us because it implies that there is an `index.html` hiding in
there.

This link [should be a relative link](rel-image).
This link [is a relative link that works][rel-image]

## HTTP links

This [link uses http, which is no bueno](http://example.com)


[rel-label-1]: #label-1
[rel-image]: image-test.html
