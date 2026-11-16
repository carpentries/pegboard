# Set the alt text for a nodeset of images

This finds the attribute curly braces after an image declaration,
extracts the alt text, and adds it as an attribute to the image, which
is useful in parsing the XML, and will not affect rendering.

## Usage

``` r
set_alt_attr(images, xpath, ns)
```

## Arguments

- images:

  a nodeset of images

- xpath:

  an XPath expression that finds the first curly brace immediately after
  a node.

- ns:

  the namespace of the XML

## Value

the nodeset, invisibly.

## Note

this function assumes that the images entering have a curly brace
following.
