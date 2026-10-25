test_that("check prepare_data_for_reactable", {
  # get parameters for data load (urls)
  url_ogd <- get_params_data_load()

  # Set input for filter
  my_input <- list(
    "adresse" = "Konrad-Ilg-Strasse 27"
  )


  # download the data
  df <- sf::st_read(url_ogd)

  # Filter the data (with input)
  data <- filter_data_with_inputs(df, my_input)

  # Make sure return object as a data frame
  expect_s3_class(prepare_data_for_reactable(data), "data.frame")

  # Make sure columns are correct
  expect_named(prepare_data_for_reactable(data), c("Ortsbezeichnung", "Wert"))
})
