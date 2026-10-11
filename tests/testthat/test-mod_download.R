my_input <- list(
  "adresse" = "Konrad-Ilg-Strasse 27"
)

filtered_data <- filter_data_with_inputs(df_main, my_input)
data_download <- prepare_data_for_csv(filtered_data)

testServer(
  mod_download_server,
  # Add here your module params
  args = list(data_download, "some_fn", create_excel, list(filtered_data, "some string")),
  {
    ns <- session$ns
    # not sure what we should test here
  }
)

test_that("module ui works", {
  ogd_link <- "https://data.stadt-zuerich.ch/dataset/geo_adressen_stadt_zuerich"
  ui <- mod_download_ui(
    id = "test",
    ogd_link
  )
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_download_ui)
  for (i in c("id")) {
    expect_true(i %in% names(fmls))
  }
})
