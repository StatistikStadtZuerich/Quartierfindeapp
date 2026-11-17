test_that("filter function works", {
  my_input <- list(
    "adresse" = "Konrad-Ilg-Strasse 27"
  )

  # expect geometry to be removed with these initial values
  expect_equal(
    filter_data_with_inputs(df_main, my_input),
    df_main |> filter(adresse == "Konrad-Ilg-Strasse 27") |>
      sf::st_drop_geometry()
  )
  expect_equal(nrow(filter_data_with_inputs(df_main, my_input)), 1)

  # check output type
  expect_s3_class(filter_data_with_inputs(df_main, my_input), "data.frame")
})
