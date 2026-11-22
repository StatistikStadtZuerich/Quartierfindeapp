my_input <- list(
  "adresse" = "Konrad-Ilg-Strasse 27"
)

filtered_data <- filter_data_with_inputs(df_main, my_input)

testServer(
  mod_download_server,
  # Add here your module params
  args = list(
    reactive(filtered_data),
    reactive(my_input$adresse),
    create_excel
  ),
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
