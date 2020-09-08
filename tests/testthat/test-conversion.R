test_that("Episodes can be converted to use sandpaper", {

  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  tags <- c(
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .language-python}",
    "{: .language-python}"
  )
  new_tags <- tags
  new_tags[grepl("python", tags)] <- NA
  langs <- ifelse(grepl("python", tags), "python", NA)

  expect_length(e$code, 11)

  # With RMD -------------------------------------------------------------------
  expect_length(e$reset()$use_sandpaper(rmd = TRUE)$code, 12)
  # ktags are converted
  expect_equal(xml2::xml_attr(e$code, "ktag"), c(NA, new_tags))
  # language tags added
  expect_equal(xml2::xml_attr(e$code, "language"), c("r", langs))
  # name tags added
  expect_match(na.omit(xml2::xml_attr(e$code, "name")), "setup|python-chunk")
  # First node is the setup chunk
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("reticulate")\n# Generated with {pegboard}'
  )

  # Without RMD ----------------------------------------------------------------
  expect_length(e$reset()$use_sandpaper(rmd = FALSE)$code, 11)
  # ktags are converted
  expect_equal(xml2::xml_attr(e$code, "ktag"), new_tags)
  # language tags added
  expect_equal(xml2::xml_attr(e$code, "info"), langs)
  expect_equal(xml2::xml_attr(e$code, "name"), rep(NA_character_, 11))
  expect_equal(xml2::xml_attr(e$code, "language"), rep(NA_character_, 11))
  # First node is text
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )

})

test_that("Episodes can be converted to use dovetail", {

  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  tags <- c(
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .language-python}",
    "{: .language-python}"
  )
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )
  expect_length(e$code, 11)
  expect_equal(xml2::xml_attr(e$code, "ktag"), tags)

  e$use_dovetail()
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("dovetail")\nsource(dvt_opts())\nknitr_fig_path("fig-")\n# Generated with {pegboard}'
  )
  # Code is still jekyll code
  expect_length(e$code, 12)
  expect_equal(xml2::xml_attr(e$code, "ktag"), c(NA, tags))

})


test_that("Conversion pipeline works", {


  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  tags <- c(
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .language-python}",
    "{: .language-python}"
  )
  expect_length(e$code, 11)
  expect_length(e$challenges, 3)
  expect_equal(xml2::xml_attr(e$code, "ktag"), tags)
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )

  # Conversion chain!!!!
  e$
    use_dovetail()$            # Convert to dovetail
    use_sandpaper(rmd = TRUE)$ # Ditch Jekyll
    remove_output()$           # remove output blocks
    remove_error()$            # remove error blocks (does nothing in this)
    unblock()$                 # Convert block quotes to code chunks
    move_keypoints()$          # move yaml metadata to actual data
    move_questions()$
    move_objectives()

  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("dovetail")\nlibrary("reticulate")\n# Generated with {pegboard}'
  )
  # Note: the last three python chunks were inside of challenges. Calculation
  # original code chunks + yaml + setup - output
  expect_length(e$code, 11 + 3 + 1 - 4)
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "info"),
    "{keypoints}"
  )

})
