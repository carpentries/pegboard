
loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
e <- Episode$new(loop)
suppressWarnings(yml <- yaml::read_yaml(file.path(e$lesson, "_config.yml")))
f <- e$clone(deep = TRUE)

test_that("links are replaced in our example", {
  e$use_sandpaper()
  orig <- pegboard:::make_link_table(e)$orig
  # No more templating should be present
  expect_false(any(grepl("[{%}]", orig)))
  expect_snapshot(orig)
})

test_that("links are replaced in messy example", {
  xml <- xml2::read_xml(test_path("examples", "link-liquid.xml"))
  dest <- xml2::xml_find_all(xml, ".//d1:link | .//d1:image")
  dest <- xml2::xml_attr(dest, "destination")
  res <- replace_links(dest, yml)
  # No more templating should be present
  expect_false(any(grepl("[{%}]", res)))
  expect_snapshot(res)
})


test_that("links to other parts of the lesson are properly accounted for", {
  ep <- Episode$new(test_path("examples", "_episodes", "test-link-fixing.md"))
  res <- ep$use_sandpaper()$validate_links(warn = FALSE)
  expected <- 
  c("link-liquid-markdown.md",
    "../handout.Rmd", 
    "../handout.Rmd", 
    "../handout.Rmd",
    "../learners/setup.md", 
    "../learners/setup.md", 
    "../instructors/instructor-notes.md",
    "../instructors/instructor-notes.md", 
    "../learners/discuss.md",
    "../learners/discuss.md", 
    "../learners/reference.md", 
    "../learners/reference.md#item",
    "code/02-episode/Makefile",
    "data/something.zip"
  )
  expect_equal(res$orig, expected)
})

