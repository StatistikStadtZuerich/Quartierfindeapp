#' create_main_reactable
#'
#' @description Function to create the main reactable to be used as an output
#'
#' @param df data.frame to be put into the reactable
#'
#' @return a reactable
#'
#' @noRd
create_main_reactable <- function(df) {
  # Kategorien unbenennen
  transposed_data <- prepare_data_for_reactable(df)

  # Create the reactable table
  reactable(
    transposed_data,
    class = "table-striped",
    columns = list(
      Ortsbezeichnung = colDef(name = "Merkmal"),
      Wert = colDef(name = "Angabe")
    ),
    defaultPageSize = nrow(transposed_data)
  )
}
