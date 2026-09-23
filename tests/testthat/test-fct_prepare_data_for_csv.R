test_that("prepare data for cvs works", {
  # prepare inputs
  my_input <- list(
    "adresse" = "Konrad-Ilg-Strasse 27"
  )
  filtered_data <- filter_data_with_inputs(df_main, my_input)

  # check output type
  expect_s3_class(prepare_data_for_csv(filtered_data), "data.frame")

  # check column numbers are equal (drop geometry, but add wahlkreis)
  expect_equal(
    nrow(prepare_data_for_csv(filtered_data)),
    nrow(filtered_data)
  )

  # check columns have been properly renamed
  # this implicitly also checks for the number of columns
  expected_names <- c(
    "plz", "stadtkreis", "statistisches_quartier", "statistische_zone",
    "verwaltungsquartier", "wahlkreis", "schulkreis",
    "ev_ref_kirchenkreis", "ev_ref_kirchgemeinde", "roem_kath_kirchgemeinde"
  )
  expect_named(prepare_data_for_csv(filtered_data), expected_names)
})
