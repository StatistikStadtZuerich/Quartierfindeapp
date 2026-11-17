# script to get the latest data from ogd and save it locally
# run locally, and will be run also in the deployment pipeline
#
# when running locally: load all as well
pkgload::load_all(attach_testthat = FALSE)

# use the functions in the R subfolders to get the data from the OGD server
# and prepare them as needed
df_main <- get_data()

adressen_sorted <- df_main |>
  arrange(
    lokalisationsname,
    hausnummer_sort
  ) |>
  pull(adresse)

usethis::use_data(df_main, adressen_sorted,
  overwrite = TRUE,
  internal = TRUE
)
