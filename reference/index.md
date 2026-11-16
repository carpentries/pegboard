# Package index

## Classes

R6 Classes that parse and manipulate Lesson content based on the {tinkr}
yarn class. All of the public-facing operations take place through the
methods in these classes.

- [`Lesson`](https://carpentries.github.io/pegboard/reference/Lesson.md)
  : Class to contain a single Lesson by the Carpentries
- [`Episode`](https://carpentries.github.io/pegboard/reference/Episode.md)
  : Class representing XML source of a Carpentries episode

## Validation Reference

Reference documentation for validation procedures

- [`validate_headings()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`heading_tests`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`heading_info`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`headings_first_heading_is_second_level()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`headings_greater_than_first_level()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`headings_are_sequential()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`headings_have_names()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  [`headings_are_unique()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
  : Validate headings
- [`validate_links()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`allowed_uri_protocols`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_known_protocol()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_enforce_https()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_all_reachable()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_img_alt_text()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_length()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_descriptive()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_source_list()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_internal_anchor()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_internal_file()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_internal_well_formed()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_tests`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  [`link_info`](https://carpentries.github.io/pegboard/reference/validate_links.md)
  : Validate Links in a markdown document
- [`validate_divs()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
  [`div_is_known()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
  [`KNOWN_DIVS`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
  [`div_tests`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
  [`div_info`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
  : Validate Callout Blocks for sandpaper episodes
- [`throw_heading_warnings()`](https://carpentries.github.io/pegboard/reference/throw_warnings.md)
  [`throw_div_warnings()`](https://carpentries.github.io/pegboard/reference/throw_warnings.md)
  [`throw_link_warnings()`](https://carpentries.github.io/pegboard/reference/throw_warnings.md)
  : Throw a validation report as a single message
- [`collect_labels()`](https://carpentries.github.io/pegboard/reference/collect_labels.md)
  : Collect and append validation messages
- [`issue_warning()`](https://carpentries.github.io/pegboard/reference/cli_helpers.md)
  [`pb_message()`](https://carpentries.github.io/pegboard/reference/cli_helpers.md)
  [`line_report()`](https://carpentries.github.io/pegboard/reference/cli_helpers.md)
  [`append_labels()`](https://carpentries.github.io/pegboard/reference/cli_helpers.md)
  [`message_muffler()`](https://carpentries.github.io/pegboard/reference/cli_helpers.md)
  : Issue a warning via CLI if it exists or send a message
- [`get_headings()`](https://carpentries.github.io/pegboard/reference/heading_utils.md)
  [`show_heading_tree()`](https://carpentries.github.io/pegboard/reference/heading_utils.md)
  : Get all headings in the XML document

## Helper functions

Miscellaneous functions that make working in Pegboard a little easier.

- [`get_lesson()`](https://carpentries.github.io/pegboard/reference/get_lesson.md)
  : Get a carpentries lesson in XML format
- [`lesson_fragment()`](https://carpentries.github.io/pegboard/reference/lesson_fragment.md)
  : Example Lesson Fragments
- [`make_heading_table()`](https://carpentries.github.io/pegboard/reference/make_heading_table.md)
  : Create a table for headings
- [`make_link_table()`](https://carpentries.github.io/pegboard/reference/make_link_table.md)
  : Create a table of parsed URLs from a single Episode object.
- [`make_div_table()`](https://carpentries.github.io/pegboard/reference/make_div_table.md)
  : Create a table of divs in an episode

## \[Internal\] functions for Episode methods

Functions in this category serve as internal functions that the
corresponding methods in the `Episode` class.

- [`get_challenges()`](https://carpentries.github.io/pegboard/reference/get_challenges.md)
  : Gather challenges from the XML body of a carpentries lesson
- [`get_solutions()`](https://carpentries.github.io/pegboard/reference/get_solutions.md)
  : Gather solutions from the XML body of a carpentries lesson
- [`isolate_elements()`](https://carpentries.github.io/pegboard/reference/isolate_elements.md)
  : Isolate elements in an XML document by source position

## \[Internal\] Div Utilities

These functions help parse, clean, and label divs (both pandoc fenced
divs and HTML divs) in the document for parsing.

- [`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md)
  : Get paired div blocks
- [`find_between_tags()`](https://carpentries.github.io/pegboard/reference/find_between_tags.md)
  : Find nodes between two nodes with a given dtag
- [`label_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md)
  [`find_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md)
  [`clear_div_labels()`](https://carpentries.github.io/pegboard/reference/div_labels.md)
  : Add labels to div tags in the form of a "dtag" node with a paired
  "label" attribute.
- [`make_div_pairs()`](https://carpentries.github.io/pegboard/reference/make_div_pairs.md)
  : Create a data frame describing the divs associated with nodes.
- [`find_div_pairs()`](https://carpentries.github.io/pegboard/reference/find_div_pairs.md)
  : Make paired labels for opening and closing div tags
- [`clean_div_tags()`](https://carpentries.github.io/pegboard/reference/clean_div_tags.md)
  : Clean the div tags from an xml document
- [`clean_fenced_divs()`](https://carpentries.github.io/pegboard/reference/clean_fenced_divs.md)
  : Clean pandoc fenced divs and place them in their own paragraph
  elements
- [`trim_fence()`](https://carpentries.github.io/pegboard/reference/trim_fence.md)
  : Trim div fences from output

## \[Internal\] Kramdown Parsers, Accessors, and Translators

Styles-era Carpentries lessons used kramdown syntax, which has a very
different set of features (such as postfix tags and liquid templating)
that require extra post-processing. These functions processed this
syntax and offerd ways of translating it to the more common pandoc
syntax. (Note, this is a non-exhaustive list).

- [`fix_links()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`find_broken_links()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`fix_broken_links()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`make_link_patterns()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`get_link_fragment_nodes()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`fix_broken_link()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`links_within_text_regex()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`text_to_links()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`make_link()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  [`find_between_nodes()`](https://carpentries.github.io/pegboard/reference/fix_links.md)
  : Find and fix unresolved template links within an Episode XML body
- [`fix_sandpaper_links()`](https://carpentries.github.io/pegboard/reference/fix_sandpaper_links.md)
  : Fix relative and jekyll links to be compatible with sandpaper
- [`fix_liquid_relative_link()`](https://carpentries.github.io/pegboard/reference/fix_liquid_relative_link.md)
  : Remove spaces in relative links with liquid variables
- [`make_pandoc_alt()`](https://carpentries.github.io/pegboard/reference/make_pandoc_alt.md)
  : Add alt text to images when transforming from jekyll to sandpaper
- [`set_alt_attr()`](https://carpentries.github.io/pegboard/reference/set_alt_attr.md)
  : Set the alt text for a nodeset of images
- [`get_blocks()`](https://carpentries.github.io/pegboard/reference/get_blocks.md)
  : Gather blocks from the XML body of a carpentries lesson
- [`get_code()`](https://carpentries.github.io/pegboard/reference/get_code.md)
  : Get code blocks from xml document
- [`liquid_to_commonmark()`](https://carpentries.github.io/pegboard/reference/liquid_to_commonmark.md)
  : Convert liquid code blocks to commonmark code blocks
- [`elevate_children()`](https://carpentries.github.io/pegboard/reference/elevate_children.md)
  : elevate all children of a node
- [`kramdown_tags()`](https://carpentries.github.io/pegboard/reference/kramdown_tags.md)
  : Find all kramdown tags within the document
- [`set_ktag_block()`](https://carpentries.github.io/pegboard/reference/set_ktag_block.md)
  : add the kramdown tags as attributes of special blocks
- [`are_blocks()`](https://carpentries.github.io/pegboard/reference/are_blocks.md)
  : test if the children of a given nodeset are kramdown blocks
