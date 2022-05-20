
loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
e <- Episode$new(loop)
suppressWarnings(yml <- yaml::read_yaml(file.path(e$lesson, "_config.yml")))
f <- e$clone(deep = TRUE)

test_that("links are replaced in our example", {
  b <- e$body
  fix_sandpaper_links(b, yml)
  orig <- pegboard:::make_link_table(e)$orig
  # No more templating should be present
  expect_false(any(grepl("[{%}]", orig)))
  expect_snapshot(orig)
})

test_that("links are replaced in messy example", {
  xml <- xml2::read_xml(test_path("examples", "link-liquid.xml"))
  xml2::xml_ns_strip(xml)
  dest <- xml2::xml_find_all(xml, ".//link | .//image")
  dest <- xml2::xml_attr(dest, "destination")
  res <- replace_links(dest, yml)
  # No more templating should be present
  expect_false(any(grepl("[{%}]", res)))
  expect_snapshot(res)
})
