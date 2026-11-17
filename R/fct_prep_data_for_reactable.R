#' prepare_data_for_reactable
#'
#' function to rename and transpose a data.frame
#'
#' @param df data.frame with data
#'
#' @return transposed data.frame
#' @noRd
#'

prepare_data_for_reactable <- function(df) {
  # Define rename mapping
  rename_map <- c(
    "Adresse" = "adresse",
    "Postleitzahl" = "plz",
    "Stadtkreis" = "stadtkreis",
    "Quartier" = "verwaltungsquartier",
    "Statistisches Quartier" = "statistisches_quartier",
    "Statistische Zone" = "statistische_zone",
    "Wahlkreis" = "wahlkreis",
    "Schulkreis" = "schulkreis",
    "Evangelischer Kirchenkreis" = "ev_ref_kirchenkreis",
    "Evangelische Kirchengemeinde" = "ev_ref_kirchgemeinde",
    "Römisch katholische Kirchengemeinde" = "roem_kath_kirchgemeinde"
  )



  # List of columns you want to select
  desired_columns <- c(
    "plz", "stadtkreis", "verwaltungsquartier", "statistisches_quartier", # "statistische_zone",
    "wahlkreis", "schulkreis", "ev_ref_kirchenkreis",
    "ev_ref_kirchgemeinde", "roem_kath_kirchgemeinde"
  )

  # Drop geometry

  df <- sf::st_drop_geometry(df)


  # First select only columns that exist in both desired_columns and dataframe
  df_selected <- df |>
    dplyr::select(all_of(intersect(desired_columns, names(df))))

  # Filter rename_map to only include columns that exist in df_selected
  filtered_rename_map <- rename_map[unname(rename_map) %in% names(df_selected)]

  # Apply renaming
  df_renamed <- df_selected |> dplyr::rename(!!!filtered_rename_map)

  # Transpose data
  transposed_data <- as.data.frame(t(df_renamed)) # Transpose
  transposed_data <- tibble::rownames_to_column(transposed_data, var = "Ortsbezeichnung") # Move row names into a column
  colnames(transposed_data)[2] <- "Wert" # Rename second column


  return(transposed_data)
}
