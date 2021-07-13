# reporters will work [plain]

    Code
      expect_false(vh$validate_headings())
    Message <cliMessage>
      ! The first heading must be a second level (##) heading. (It is currently level 1)
      ! First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      ! All headings must be sequential
      ! All headings must be named

# reporters will work [ansi]

    Code
      expect_false(vh$validate_headings())
    Message <cliMessage>
      [33m![39m The first heading must be a second level (##) heading. (It is currently level 1)
      [33m![39m First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      [33m![39m All headings must be sequential
      [33m![39m All headings must be named

# reporters will work [unicode]

    Code
      expect_false(vh$validate_headings())
    Message <cliMessage>
      ! The first heading must be a second level (##) heading. (It is currently level 1)
      ! First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      ! All headings must be sequential
      ! All headings must be named

# reporters will work [fancy]

    Code
      expect_false(vh$validate_headings())
    Message <cliMessage>
      [33m![39m The first heading must be a second level (##) heading. (It is currently level 1)
      [33m![39m First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      [33m![39m All headings must be sequential
      [33m![39m All headings must be named

