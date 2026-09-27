test_that("check that function to create main reactable works", {
  # prepare inputs
  my_inputs <- list(
    "adresse" = "Napfgasse 6"
  )
  filtered_data <- filter_data_with_inputs(df_main, my_inputs)
  wrangled_data <- prepare_data_for_reactable(filtered_data)

  # check data type
  expect_s3_class(
    create_main_reactable(wrangled_data),
    "reactable"
  )

  # check dimensions
  expect_equal(
    length(create_main_reactable(filtered_data)$x$tag$attribs$columns),
    2
  )
  # expect_equal(
  #   length(dplyr::last(jsonlite::parse_json(
  #     create_main_reactable(filtered_data)$x$tag$attribs$data
  #   ))),
  #   nrow(filtered_data)
  # )
})
