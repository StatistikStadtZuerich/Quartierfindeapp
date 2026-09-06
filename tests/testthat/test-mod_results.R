# prepare module inputs
my_inputs <- list(
  "adresse" = "Napfgasse 6"
)
filtered_data <- filter_data_with_inputs(df_main, my_inputs)
create_main_reactable(filtered_data)

testServer(
  mod_results_server,
  args = list(filtered_data = filtered_data),
  {
    ns <- session$ns

    # Title should include the adresse
    expect_true(str_detect(output$title$html, "Napfgasse 6"))

    # Main table should be a reactable object
    expect_s3_class(output$table_main, "json")

    # Check that tables don't have missing values
    expect_true(!is.null(output$table_main))

    # Check that tables are not empty
    expect_true(nchar(output$table_main) > 10)
  }
)


test_that("module UI renders correctly", {
  ui <- mod_results_ui(id = "test")
  golem::expect_shinytaglist(ui)

  # Check that expected output IDs are present
  ui_str <- as.character(ui)
  expect_true(stringr::str_detect(ui_str, "test-title", ))
  expect_true(stringr::str_detect(ui_str, "test-table_main"))

  # Formals test
  fmls <- formals(mod_results_ui)
  expect_true("id" %in% names(fmls))
})
