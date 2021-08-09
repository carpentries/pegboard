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
wrong](incorrect-link.html). 

[This link also goes to image test](image-test) and [_this_ link goes to
image test as well](./image-test.html)
[This link also goes to image test, but with a slash](image-test/), though this
may not work for us because it implies that there is an `index.html` hiding in
there.

This link [should be a relative link](rel-image).
This link [is a relative link that works][rel-image]

## HTTP links

This [link uses http, which is no bueno](http://example.com)

## Link text

If we have [link text that is informative](https://example.com/link-text#good),
it will pass.

If we have links like 
[this][bad-link-text]
[link][bad-link-text]
[this link][bad-link-text]
[a link][bad-link-text]
[link to][bad-link-text]
[here][bad-link-text]
[here for][bad-link-text]
[click here for][bad-link-text]
[over here for][bad-link-text]
[more][bad-link-text]
[more about][bad-link-text]
[for more about][bad-link-text]
[for more info about][bad-link-text]
[for more information about][bad-link-text]
[read more about][bad-link-text]
[read more][bad-link-text]
[read on][bad-link-text]
[read on about][bad-link-text],
[a][bad-link-text],
[][bad-link-text]
they will fail.


[rel-label-1]: #label-1
[rel-image]: image-test.html
[bad-link-text]: https://example.com/link-text#bad
