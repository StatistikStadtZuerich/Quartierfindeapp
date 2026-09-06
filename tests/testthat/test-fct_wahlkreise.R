test_that("Wahlkreiszuweisung ist richtig", {
  stadtkreis_values <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
  df <- data.frame(stadtkreis = stadtkreis_values)
  result <- add_wahlkreis(df)

  # Check that the 12 inputs are assigned to 9 outputs

  expect_length(unique(result$wahlkreis), 9)

  # Check that values are correctly assigned

  expect_equal(result$wahlkreis, c("1 + 2", "1 + 2", "3", "4 + 5", "4 + 5", "6", "7 + 8", "7 + 8", "9", "10", "11", "12"))
})
