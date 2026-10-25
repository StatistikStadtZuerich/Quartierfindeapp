library(shinytest2)

test_that("check inputs and outputs with two sets of inputs", {
  app <- AppDriver$new(name = "check-inputs", height = 1010, width = 880)

  Sys.sleep(2)

  # Set input to trigger a new output
  app$set_inputs("input_1-adresse" = "Napfgasse 6")

  # Click the action button with a timeout of 30 seconds
  app$click("action_button", timeout_ = 2) # Increased timeout to 30 seconds

  # Optional: Allow some time for the server to process the action (if needed)
  Sys.sleep(2)

  # Check the expected values
  app$expect_values()
  expect_true(!is.null("results_1-title"))
  expect_true(!is.null("results_1-table"))
  expect_true(!is.null("collapsible_section"))
})



test_that("check downloads", {
  app <- AppDriver$new(name = "check-downloads", height = 1010, width = 880)

  Sys.sleep(2)

  # Set input to trigger a new output
  app$set_inputs("input_1-adresse" = "Napfgasse 6")

  app$click("action_button", timeout_ = 2)
  Sys.sleep(2)

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
  # Click download button after waiting a bit
  Sys.sleep(2)
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
