#' get_data
#'
#' @description Function to get the necessary data from the OGD portal and return it in a wrangled form
#'
#'
#' @return a df
#' @export
#'
#' @examples
#' data <- get_data()
get_data <- function() {
  url_ogd <- get_params_data_load()

  # download the data, get rid of columns we don't need (especially those that contain only NAs)
  sf::st_read(url_ogd) |>
    select(-geometrie_gdo, -li_nummer_projektiert, -gebaeudenummer)
}
