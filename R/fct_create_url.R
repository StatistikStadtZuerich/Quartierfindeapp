#' Build Stadtplan URL from a single-row data.frame
#'
#' @param data A data.frame containing at least the columns:
#'   lokalisationsname, hausnummer, gebaeudeeingangnummer
#'
#' @return A character string with the URL
#' @export
build_stadtplan_url <- function(data) {
  stopifnot(nrow(data) == 1)
  # Extract values safely
  lok <- data$lokalisationsname
  hnr <- data$hausnummer
  eingang <- data$gebaeudeeingangnummer

  # Construct the full URL
  paste0(
    "https://www.maps.stadt-zuerich.ch/zueriplan3/Stadtplan.aspx?adresse=",
    lok, "%20", hnr,
    "&selectedObject=adr", eingang,
    "&toggleScreen=1"
  )
}


#' Build Quartierspiegel URL from a single-row data.frame
#'
#' @param data A data.frame containing at least the columns:
#'   quartier_nr
#'
#' @return A character string with the URL
#' @export
build_quartierspiegel_url <- function(data) {
  stopifnot(nrow(data) == 1)
  # Get quartiernummer (numeric, can be 2 or 3 digits)
  quartier_nr <- data$statistisches_quartier_nr

  # link always needs 3 digits --> pad with zero if necessary
  if (quartier_nr < 100) {
    quartier_string <- paste0("0", quartier_nr)
  } else {
    quartier_string <- as.character(quartier_nr)
  }
  
  # Construct the full URL
  paste0(
    "https://www.stadt-zuerich.ch/de/politik-und-verwaltung/statistik-und-daten/publikationen-und-dienstleistungen/publikationen/quartierspiegel/quartier-", quartier_string, ".html"
  )
}
