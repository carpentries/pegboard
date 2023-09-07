---
title: "Test for markdown content inside liquid links"
---


[_markdown formatted_ liquid link]({{ page.root}}{% link _episodes/test.md %})
[second _markdown formatted_ liquid link]({{ page.root}}{% link _episodes/test.md %})
[third _markdown formatted_ liquid link]({{ page.root }}/test/)

![third _markdown formatted_ liquid image]({{ page.root }}/../fig/test.png)

[normal liquid link]({{ page.root}}{% link _episodes/test.md %})

[first _markdown formatted_ relative link](../test/)
[second _markdown formatted_ relative link](../test/index.html)
[third _markdown formatted_ relative link](/lesson/test/index.html)

[_markdown formatted_ liquid link](https://example.com/test/)
[second _markdown formatted_ liquid link](https://example.com/test/)
[third _markdown formatted_ liquid link](https://example.com/test/)

