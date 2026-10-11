#' add_wahlkreis
#'
#' @description A function that determines the "Wahlkreis" based on the "Stadtkreis" in the city of Zurich.
#'
#'
#' @return the data frame with an additional column called Wahlkreis
#' @export
#'
#' @examples
#' data <- add_wahlkreis(df)
add_wahlkreis <- function(df) {
  df |>
    mutate(wahlkreis = case_when(
      stadtkreis %in% c(1, 2) ~ "1 + 2",
      stadtkreis %in% c(4, 5) ~ "4 + 5",
      stadtkreis %in% c(7, 8) ~ "7 + 8",
      TRUE ~ as.character(stadtkreis)
    ))
}
