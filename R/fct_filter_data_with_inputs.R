#' filter_data_with_inputs
#'
#' @description Function to filter the main data according to the selected inputs
#' @param df data.frame with main data
#' @param input_values the input values to be filtered
#'
#' @return filtered data.frame
#'
#' @noRd
filter_data_with_inputs <- function(df, input_value) {
  # Check if the input value is an empty string and return NULL if true
  # Proceed with the filtering
  df |>
    sf::st_drop_geometry() |>
    # Drop geometry
    filter(tolower(adresse) == tolower(input_value$adresse)) |>
    # Gebäude können aufgrund von Gebäudestatus mehrmals vorkommen,
    # da die anderen Variablen identisch sind, wird hier nach dem ersten Hit gefiltert
    slice_head(n = 1)
}
