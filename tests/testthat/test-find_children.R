test_that("Sandpaper lessons will have children listed", {
  # setup -------------------------------------------------------------------
  tmp <- withr::local_tempdir()
  test_dir <- fs::path(tmp, "sandpaper-fragment")
  fs::dir_copy(lesson_fragment("sandpaper-fragment"), test_dir)
  fs::dir_copy(
    test_path("examples", "child-example", "files"),
    fs::path(test_dir, "episodes")
  )
  # create two files in the lesson with the same children -------------------
  parent_file <- fs::path(test_dir, "episodes", "intro.Rmd")
  second_parent_file <- fs::path(test_dir, "episodes", "next.Rmd")
  fs::file_copy(
    test_path("examples", "child-example", "parent.Rmd"),
    parent_file,
    overwrite = TRUE
  )
  fs::file_copy(
    test_path("examples", "child-example", "parent.Rmd"),
    second_parent_file,
    overwrite = TRUE
  )
  # set the order in the config --------------------------------------------
  cfg <- readLines(fs::path(test_dir, "config.yaml"))
  eplist <- which(endsWith(cfg, "intro.Rmd"))
  cfg[eplist] <- paste0(cfg[eplist], "\n  - next.Rmd")
  writeLines(cfg, fs::path(test_dir, "config.yaml"))
  children_names <- fs::path(
    test_dir, "episodes", "files",
    c("child.md", "child-2.Rmd", "child-3.md")
  )

  lsn <- Lesson$new(test_dir, jekyll = FALSE)

  expect_true(lsn$has_children)

  expect_length(lsn$children, 3L)
  expect_length(lsn$episodes, 2L)
  expect_equal(
    fs::path_rel(names(lsn$children), lsn$path),
    fs::path_rel(children_names, lsn$path)
  )

  build_parents <- c(parent_file, second_parent_file)

  # `$parents` should reflect the immediate ancestors
  expect_equal(lsn$children[[1]]$parents, build_parents)
  expect_equal(lsn$children[[2]]$parents, build_parents)
  expect_equal(fs::path(lsn$children[[3]]$parents), children_names[[2]])

  # `$children` will return the immediate child files
  expect_true(lsn$episodes[[1]]$has_children)
  expect_equal(lsn$episodes[[1]]$children, children_names[1:2])
  expect_true(lsn$episodes[[2]]$has_children)
  expect_equal(lsn$episodes[[2]]$children, children_names[1:2])

  # `$lineage` will return the lineage of all the children
  lineage1 <- unclass(c(build_parents[[1]], children_names))
  lineage2 <- unclass(c(build_parents[[2]], children_names))
  expect_equal(lsn$trace_lineage(build_parents[[1]]), lineage1)
  expect_equal(lsn$trace_lineage(build_parents[[2]]), lineage2)


  # `$build_parents` should reflect distant ancestors
  expect_equal(lsn$children[[1]]$build_parents, build_parents)
  expect_equal(lsn$children[[2]]$build_parents, build_parents)
  expect_equal(lsn$children[[3]]$build_parents, build_parents)
})


cli::test_that_cli("children are validated along with parents", {
  # setup -------------------------------------------------------------------
  tmp <- withr::local_tempdir()
  test_dir <- fs::path(tmp, "sandpaper-fragment")
  fs::dir_copy(lesson_fragment("sandpaper-fragment"), test_dir)
  fs::dir_copy(
    test_path("examples", "child-example", "files"),
    fs::path(test_dir, "episodes")
  )
  # create two files in the lesson with the same children -------------------
  parent_file <- fs::path(test_dir, "episodes", "intro.Rmd")
  second_parent_file <- fs::path(test_dir, "episodes", "next.Rmd")
  fs::file_copy(
    test_path("examples", "child-example", "parent.Rmd"),
    parent_file,
    overwrite = TRUE
  )
  fs::file_copy(
    test_path("examples", "child-example", "parent.Rmd"),
    second_parent_file,
    overwrite = TRUE
  )
  # set the order in the config --------------------------------------------
  cfg <- readLines(fs::path(test_dir, "config.yaml"))
  eplist <- which(endsWith(cfg, "intro.Rmd"))
  cfg[eplist] <- paste0(cfg[eplist], "\n  - next.Rmd")
  writeLines(cfg, fs::path(test_dir, "config.yaml"))
  children_names <- fs::path(
    test_dir, "episodes", "files",
    c("child.md", "child-2.Rmd", "child-3.md")
  )

  lsn <- Lesson$new(test_dir, jekyll = FALSE)

  expect_snapshot(lnk <- lsn$validate_links())
  expect_s3_class(lnk, "data.frame")
  expect_paths <- c("learners/setup.md", "learners/setup.md", "episodes/files/child.md", "episodes/files/child-3.md")
  expect_equal(lnk$filepath, fs::path(expect_paths))
  expect_equal(lnk$internal_file, c(TRUE, TRUE, FALSE, TRUE))
  expect_equal(lnk$enforce_https, c(FALSE, FALSE, TRUE, TRUE))
})

