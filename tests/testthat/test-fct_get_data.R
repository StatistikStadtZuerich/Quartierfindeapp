test_that("there are no missing values", {
  df <- get_data()
  # there should be no missing values
  expect_equal(sum(is.na(df)), 0)
})


test_that("the data has a believable number of rows", {
  df <- get_data()

  expect_lt(nrow(df), 70000)

  expect_gt(nrow(df), 50000)
})


test_that("Alle Kreise und Quartiere sind in den Daten vertreten", {
  df <- get_data()

  expect_equal(length(unique(df$stadtkreis)), 12)

  expect_equal(length(unique(df$statistisches_quartier)), 34)
})

test_that("Alle nötigen Spalten sind in den Daten vorhanden", {
  df <- get_data()

  verwendete_spalten <- c(
    "adresse",
    "plz",
    "stadtkreis",
    "statistisches_quartier",
    "statistische_zone",
    "verwaltungsquartier",
    "schulkreis",
    "ev_ref_kirchenkreis",
    "ev_ref_kirchgemeinde",
    "roem_kath_kirchgemeinde"
  )

  expect_true(all(verwendete_spalten %in% names(df)))
})
