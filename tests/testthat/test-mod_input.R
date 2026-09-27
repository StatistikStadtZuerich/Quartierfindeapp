testServer(
  mod_input_server,
  # Add here your module params
  args = list(),
  {
    ns <- session$ns
    session$setInputs(
      "adresse" = "Napfgasse 6"
    )
    # Check returned
    res <- session$returned
    expect_named(res, c(
      "filtered_data", "current_inputs"
    ))

    # make sure output assignment worked
    expect_identical(res$filtered_data(), filtered_data())

    # check output types
    expect_s3_class(filtered_data(), "data.frame")
    expect_type(res$current_inputs, "list")
    expect_named(res$current_inputs, "adresse")
    expect_true(is.reactive(res$current_inputs$adresse))
    expect_identical(res$current_inputs$adresse(), "Napfgasse 6")

    # check has_changed actually changes when new input is set
    # initial_has_changed <- has_changed()
    # session$setInputs(
    #   "select_liste" = "Grüne"
    # )
    # expect_false(initial_has_changed == has_changed())
  }
)

test_that("module ui works", {
  ui <- mod_input_ui(id = "test", icons::icon_set(here::here("inst/app/www/icons/")))
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_input_ui)
  for (i in c("id")) {
    expect_true(i %in% names(fmls))
  }
})
