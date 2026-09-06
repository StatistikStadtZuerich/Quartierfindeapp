#' prepare_data_for_csv
#'
#' @description A function to prepare the filtered data for the csv download (human-readable column names etc.)
#'
#' @return data frame
#'
#' @noRd
prepare_data_for_csv <- function(data_for_csv) {
  data_for_csv |>
    add_wahlkreis() |>
    dplyr::select(
      plz, stadtkreis, statistisches_quartier, statistische_zone,
      verwaltungsquartier, wahlkreis, schulkreis,
      ev_ref_kirchenkreis, ev_ref_kirchgemeinde, roem_kath_kirchgemeinde
    ) |>
    sf::st_drop_geometry()
}
