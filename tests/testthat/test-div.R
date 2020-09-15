test_that("div pairs are uniquely labelled", {
  nodes <- c(
  "<div class='1'>", 
    "<div class='2'>" , 
    "</div>", 
    "<div class='2'>", 
      "<div class='3'>", 
      "</div>", 
    "</div>", 
  "</div>")
  out <- pegboard:::get_div_levels(nodes)
  expect_equal(out, c(1, 2, 0, 2, 3, 0, 0, 0))
  out <- pegboard:::get_div_levels(c(nodes, nodes))
  expect_equal(out, c(
      1, 2, 0, 2, 3, 0, 0, 0, 
      1, 2, 0, 2, 3, 0, 0, 0
  ))
  out <- pegboard:::get_div_levels(nodes[c(1, 3)])
  expect_equal(out, c(1, 0))
})

test_that("div pairs are uniquely labelled", {
  nodes <- c(
  "<div class='1'>", 
    "<div class='2'>" , 
    "</div>", 
    "<div class='2'>", 
      "<div class='3'>", 
      "</div>", 
    "</div>", 
  "</div>")
  out <- pegboard:::make_pairs(nodes)
  expect_equal(out, c(1, 3, 3, 5, 8, 8, 5, 1))
  out <- pegboard:::make_pairs(c(nodes, nodes))
  expect_equal(out, c(
      1, 3 , 3 , 5 , 8 , 8 , 5 , 1,
      9, 11, 11, 13, 16, 16, 13, 9
    ))
  out <- pegboard:::make_pairs(nodes[c(1, 3)])
  expect_equal(out, c(1, 1))
})
