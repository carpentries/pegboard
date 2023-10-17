# div CLI messages work [plain]

    Code
      expect_error(label_div_tags(ex))
    Message
      x A section (div) tag mis-match was detected.
      x There are not enough close tags (2) for the number of open tags (3).

# div CLI messages work [ansi]

    Code
      expect_error(label_div_tags(ex))
    Message
      [31mx[39m A section (div) tag mis-match was detected.
      [31mx[39m There are not enough close tags (2) for the number of open tags (3).

# div CLI messages work [unicode]

    Code
      expect_error(label_div_tags(ex))
    Message
      ✖ A section (div) tag mis-match was detected.
      ✖ There are not enough close tags (2) for the number of open tags (3).

# div CLI messages work [fancy]

    Code
      expect_error(label_div_tags(ex))
    Message
      [31m✖[39m A section (div) tag mis-match was detected.
      [31m✖[39m There are not enough close tags (2) for the number of open tags (3).

