# Isolate all blocks within a document that have a kramdown tag

Isolate all blocks within a document that have a kramdown tag

## Usage

``` r
isolate_kram_blocks(body, predicate = "")
```

## Arguments

- body:

  an xml document

- predicate:

  an XPath conditional statement in square brackets or an empty string.
  This can be used to filter on such attributes such as line number.

## Value

the modified body, invisibly
