#' get_params_data_load
#'
#' @description A utils function: the place where hardcoded things like links are set
#'
#' @return a list with urls to data sources
#'
#' @noRd
get_params_data_load <- function() {
  # URLs for ogd data
  url_ogd <-
    # Adressen
    "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Adressen_Stadt_Zuerich?service=WFS&version=1.1.0&request=GetFeature&outputFormat=application/json&typename=adrstzh_adressen_stzh_p"


  # if there are more things to be hardcoded (e.g. years, more data), turn the return value into a list
  return(url_ogd)
}

#' data_download
#' @description Function to download the data from Open Data Zürich
#'
#' @param link URL to the csv
#'
#' @return data.frame
#' @noRd
data_download <- function(link) {
  data.table::fread(link, encoding = "UTF-8") |>
    janitor::clean_names()
  # if needed, do additional things like e.g. encoding of date columns
}
