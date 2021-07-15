# reporters will work [plain]

    Code
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      ! The first heading must be a second level (##) heading. (It is currently level 1)
      ! First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      ! All headings must be sequential
      ! All headings must be named
      ! All headings must have unique IDs
      The following headings are duplicated:
      <LESSON>
      +-# First heading throws an error
      | +-### This heading throws another error
      | +-## This heading is okay
      | +-## This heading is okay <- (duplicated)
      | +-## 
      | \-## This last heading is okay
      \-## This heading is okay <- (duplicated)

# reporters will work [ansi]

    Code
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      [33m![39m The first heading must be a second level (##) heading. (It is currently level 1)
      [33m![39m First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      [33m![39m All headings must be sequential
      [33m![39m All headings must be named
      [33m![39m All headings must have unique IDs
      The following headings are duplicated:
      <LESSON>
      +-# First heading throws an error
      | +-### This heading throws another error
      | +-## This heading is okay
      | +-## This heading is okay [7m<- (duplicated)[27m
      | +-## 
      | \-## This last heading is okay
      \-## This heading is okay [7m<- (duplicated)[27m

# reporters will work [unicode]

    Code
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      ! The first heading must be a second level (##) heading. (It is currently level 1)
      ! First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      ! All headings must be sequential
      ! All headings must be named
      ! All headings must have unique IDs
      The following headings are duplicated:
      <LESSON>
      ├─# First heading throws an error
      │ ├─### This heading throws another error
      │ ├─## This heading is okay
      │ ├─## This heading is okay <- (duplicated)
      │ ├─## 
      │ └─## This last heading is okay
      └─## This heading is okay <- (duplicated)

# reporters will work [fancy]

    Code
      expect_false(all(vh$validate_headings()))
    Message <cliMessage>
      [33m![39m The first heading must be a second level (##) heading. (It is currently level 1)
      [33m![39m First level headings are not allowed (the title is the first level heading).
      The following heading is first level: 
      # First heading throws an error
      [33m![39m All headings must be sequential
      [33m![39m All headings must be named
      [33m![39m All headings must have unique IDs
      The following headings are duplicated:
      <LESSON>
      ├─# First heading throws an error
      │ ├─### This heading throws another error
      │ ├─## This heading is okay
      │ ├─## This heading is okay [7m<- (duplicated)[27m
      │ ├─## 
      │ └─## This last heading is okay
      └─## This heading is okay [7m<- (duplicated)[27m

