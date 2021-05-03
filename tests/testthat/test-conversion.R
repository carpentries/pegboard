test_that("conversions with empty bodies won't result in an error", {

  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  e$body <- xml2::xml_missing()
  expect_warning(e$use_sandpaper(), "episode body missing")
  expect_warning(e$use_dovetail(), "episode body missing")

})

test_that("Episodes can be converted to use sandpaper", {

  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  # insert artificial links
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
  infos <- ifelse(grepl("python", tags), "python", "output")
  langs <- ifelse(grepl("python", tags), "python", NA)
  rel_links <- xml2::xml_find_all(
    e$body, 
    ".//*[contains(text(), '../') or contains(@destination, '../')]"
  )
  jek_links <- xml2::xml_find_all(
    e$body,
    ".//d1:link[contains(@destination, '{{')]"
  )

  liquid_links <- xml2::xml_find_all(
    e$body,
    ".//d1:text[contains(text(),'include links.md') and contains(text(),'{%')]"
  )
  expect_length(liquid_links, 1)
  expect_equal(xml2::xml_text(liquid_links), "{% include links.md %}")

  expect_length(e$code, 11)
  expect_length(rel_links, 2)
  expect_equal(xml_name(rel_links), c("html_block", "image"))
  expect_equal(
    xml2::xml_attr(rel_links, "destination"),
    c(NA, "../no-workie.svg")
  )
  expect_length(jek_links, 2)
  expect_equal(
    xml2::xml_attr(jek_links, "destination"),
    c("{{ page.root }}/index.html", "{{ site.swc_pages }}/shell-novice")
  )

  # With RMD -------------------------------------------------------------------
  expect_length(e$use_sandpaper(rmd = TRUE)$code, 12)
  # ktags are converted
  expect_equal(xml2::xml_attr(e$code, "ktag"), rep(NA_character_, 12)) 
  # but the block quotes are still there
  expect_length(e$tags, 3 + 3)
  # language tags added
  expect_equal(xml2::xml_attr(e$code, "language"), c("r", langs))
  # name tags added
  expect_match(xml2::xml_attr(e$code, "name"), "^(setup|python-chunk-.+)*$")
  # First node is the setup chunk
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("reticulate")\n# Generated with {pegboard}'
  )
  # Links are converted
  expect_match(xml2::xml_attr(rel_links[[2]], "destination"), 'no-workie.svg', fixed = TRUE)
  expect_match(xml2::xml_text(rel_links[[1]]), '"no-workie.svg"', fixed = TRUE)
  expect_equal(
    xml2::xml_attr(jek_links, "destination"),
    c("index.html", "https://swcarpentry.github.io/shell-novice")
  )

  liquid_links <- xml2::xml_find_all(
    e$body,
    ".//d1:text[contains(text(),'include links.md') and contains(text(),'{%')]"
  )
  expect_length(liquid_links, 0)

  # output needs to be explicitly removed
  expect_length(e$output, 4) 
  expect_match(xml2::xml_attr(e$output, "info"), "output")

  # Without RMD ----------------------------------------------------------------
  expect_length(e$reset()$use_sandpaper(rmd = FALSE)$code, 11)
  # language tags added
  expect_equal(xml2::xml_attr(e$code, "info"), infos)
  # ktags are converted
  expect_equal(xml2::xml_attr(e$code, "ktag"), rep(NA_character_, 11))
  # but the block quotes are still there
  expect_length(e$tags, 3 + 3)
  expect_equal(xml2::xml_attr(e$code, "name"), rep("", 11))
  expect_equal(xml2::xml_attr(e$code, "language"), rep(NA_character_, 11))
  # First node is text
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )
  # output needs to be explicitly removed
  expect_length(e$output, 4) 
  expect_match(xml2::xml_attr(e$output, "info"), "output")

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


test_that("Integration: rmarkdown sandpaper sites", {

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
  expect_length(e$solutions, 3)
  # 11 code blocks + 3 challenges + 3 solutions
  expect_length(e$tags, 11 + 3 + 3)
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
  # No kramdown tags exist
  expect_length(e$tags, 0)
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "info"),
    NA_character_
  )
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "language"),
    "keypoints"
  )

})

test_that("Integration: for markdown sandpaper sites", {

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
  expect_length(e$solutions, 3)
  # 11 code blocks + 3 challenges + 3 solutions
  expect_length(e$tags, 11 + 3 + 3)
  expect_equal(xml2::xml_attr(e$code, "ktag"), tags)
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )

  # Conversion chain!!!!
  e$
    use_dovetail()$             # Convert to dovetail
    use_sandpaper(rmd = FALSE)$ # Ditch Jekyll, but keep markdown
    unblock()$                  # Convert block quotes to code chunks
    move_keypoints()$           # move yaml metadata to actual data
    move_questions()$
    move_objectives()

  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("dovetail")\n# Generated with {pegboard}'
  )
  # Note: the last three python chunks were inside of challenges. Calculation
  # original code chunks + yaml + setup - output
  expect_length(e$code, 11 + 3 + 1)
  # python code chunks exist
  expect_true(any(grepl("python", xml2::xml_attr(e$code, "info"))))
  expect_true(any(grepl("output", xml2::xml_attr(e$code, "info"))))
  # No kramdown tags exist
  expect_length(e$tags, 0)
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "info"),
    NA_character_
  )
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "language"),
    "keypoints"
  )

})

test_that("Integration: for markdown sandpaper sites without dovetail", {

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
  expect_length(e$solutions, 3)
  # 11 code blocks + 3 challenges + 3 solutions
  expect_length(e$tags, 11 + 3 + 3)
  expect_equal(xml2::xml_attr(e$code, "ktag"), tags)
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )

  e$
    use_sandpaper(rmd = FALSE)$ # Ditch Jekyll, but keep markdown
    unblock()$                  # Convert block quotes to code chunks
    move_keypoints()$           # move yaml metadata to actual data
    move_questions()$
    move_objectives()

  # The first child is not an RMD chunk
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )
  # NOTE: at the moment, we don't have a non-dovetail solution, but we're getting
  # there!
  expect_length(e$code, 11)
  # python code chunks exist
  expect_true(any(grepl("python", xml2::xml_attr(e$code, "info"))))
  expect_true(any(grepl("output", xml2::xml_attr(e$code, "info"))))
  # No kramdown tags exist
  expect_length(e$tags, 0)
  expect_match(
    xml2::xml_text(xml2::xml_child(e$body, length(xml2::xml_children(e$body)) - 1L)),
    ":::::::::::::::",
    fixed = TRUE
  )

})

test_that("Integration: jekyll sites", {


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
  expect_length(e$solutions, 3)
  # 11 code blocks + 3 challenges + 3 solutions
  expect_length(e$tags, 11 + 3 + 3)
  expect_equal(xml2::xml_attr(e$code, "ktag"), tags)
  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    "Use a for loop to process files given a list of their names."
  )

  # Conversion chain!!!!
  e$
    use_dovetail()$            # Convert to dovetail
    unblock()$                 # Convert block quotes to code chunks
    move_keypoints()$          # move yaml metadata to actual data
    move_questions()$
    move_objectives()

  expect_equal(xml2::xml_text(xml2::xml_child(e$body)), 
    'library("dovetail")\nsource(dvt_opts())\nknitr_fig_path("fig-")\n# Generated with {pegboard}'
  )
  # Note: the last three python chunks were inside of challenges. Calculation
  # original code chunks + yaml + setup
  expect_length(e$code, 11 + 3 + 1)
  # kramdown/liquid tags still exist (three python chunks are inside challenges)
  expect_length(e$tags, 11 - 3) 
  expect_equal(xml2::xml_attr(xml2::xml_parent(e$tags), "ktag"), tags[1:8])

  # Note: the last three python chunks were inside of challenges. Calculation
  # original code chunks + yaml + setup - output
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "info"),
    NA_character_
  )
  expect_equal(
    xml2::xml_attr(xml2::xml_child(e$body, length(xml2::xml_children(e$body))), "language"),
    "keypoints"
  )
  # output needs to be explicitly removed
  expect_length(e$output, 4) 
  expect_match(xml2::xml_attr(e$output, "ktag"), "{: .output}", fixed = TRUE)


})
