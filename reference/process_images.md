# Set alt attribute for image nodes; extract images from HTML blocks

Markdown specification is not always clear about what goes in the text
part of an image. Pandoc specifies a markdown image as ![alt="alt
text"](figures/img.png) Since commonmark does not recognize the
alt-text, we need to find it ourselves.

## Usage

``` r
process_images(images, ns = tinkr::md_ns())
```

## Arguments

- images:

  an XML nodelist that contains blocs with image information

- ns:

  the namespace to use

## Value

a copy of the nodelist

## Details

Moreover, it's possible to include HTML images, so we need to parse the
HTML to expose the alt text.
