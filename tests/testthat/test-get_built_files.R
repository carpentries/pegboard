
test_that("get_built_files() will read in lessons on the fly if needed", {
  built <- get_built_files(lesson_fragment("sandpaper-fragment"))
  expect_length(built, 5L)
  expect_s3_class(built[[1]], "Episode")
  expect_setequal(fs::path_file(purrr::map_chr(built, "path")), 
    c("a.md", "b.md", "index.md", "intro.md", "setup.md")
  )
})

