library(shinytest2)

test_that("check inputs and outputs with two sets of inputs", {
  app <- AppDriver$new(
    app_dir = run_app,
    name = "check-inputs",
    height = 1010,
    width = 880
  )

  # Set input to trigger a new output
  app$set_inputs("input_1-adresse" = "Napfgasse 6")

  # Click the action button
  app$click("action_button")
  app$wait_for_idle()

  # Check the expected values
  # check warning separately, as this is not recorded with devtools::test
  # (but then appears as a failure with devtools::check)
  # i.e. check selected outputs and all inputs
  outs <- setdiff(names(app$get_values()$output), "warning")
  app$expect_values(output = outs, input = TRUE)
  expect_true(!is.null("results_1-title"))
  expect_true(!is.null("results_1-table"))
  expect_true(!is.null("collapsible_section"))
  expect_match(app$get_text("#warning"), "")

  app$set_inputs("input_1-adresse" = "das ist keine Strasse in Züri")
  app$click("action_button")
  app$wait_for_idle()
  expect_match(app$get_text("#warning"), "Züri")
})


test_that("check downloads", {
  app <- AppDriver$new(
    app_dir = run_app,
    name = "check-downloads",
    height = 1010,
    width = 880
  )

  # Set input to trigger a new output
  app$set_inputs("input_1-adresse" = "Napfgasse 6")

  app$click("action_button", timeout_ = 2)
  app$wait_for_idle()

  # check csv download
  app$expect_download("download_1-csv_download", name = "download1.csv")

  # check excel: as metadata is different every time, get file and
  # compare only the content
  # not tested like this: the image and the date on the first sheet
  temp_excel_file <- "Napfgasse 6_geografische_Angaben.xlsx"
  app$get_download("download_1-excel_download", temp_excel_file)
  sheet1 <- read.xlsx(temp_excel_file, sheet = 1, colNames = F)
  # only test first 3 columns, 4th columns contains date
  expect_snapshot(sheet1[, 1:3])
  sheet2 <- read.xlsx(temp_excel_file, sheet = 2, colNames = F)
  expect_snapshot(sheet2)
  file.remove(temp_excel_file)

  # adjust inputs
  app$set_inputs("input_1-adresse" = "Kaminfegergasse 5")
  app$click("action_button")
  app$wait_for_idle()

  # check csv downloads again
  app$expect_download("download_1-csv_download")

  # check excel: as metadata is different every time, get file and
  # compare only the content
  # not tested like this: the image and the date on the first sheet
  temp_excel_file <- "Kaminfegergasse 5_geografische_Angaben.xlsx"
  app$get_download("download_1-excel_download", temp_excel_file)
  sheet1 <- read.xlsx(temp_excel_file, sheet = 1, colNames = F)
  # only test first 3 columns, 4th columns contains date
  expect_snapshot(sheet1[, 1:3])
  sheet2 <- read.xlsx(temp_excel_file, sheet = 2, colNames = F)
  expect_snapshot(sheet2)
  file.remove(temp_excel_file)
})
