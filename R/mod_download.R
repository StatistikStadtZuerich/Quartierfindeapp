#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param ogd_link url to be used with OGD button
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_ui <- function(id, ogd_link) {
  ns <- NS(id)

  tagList(
    # Download Panel
    div(
      class = "button-div",
      tags$div(
        id = ns("downloadWrapperId"), # used to show/hide the entire div
        class = "downloadWrapperDiv", # used for responsive styling
        sszDownloadButton(
          outputId = ns("csv_download"),
          label = "CSV",
          image = icons_stzh()("download")
        ),
        sszDownloadButton(
          outputId = ns("excel_download"),
          label = "XLSX",
          image = icons_stzh()("download")
        ),
        sszOgdDownload(
          outputId = ns("ogd_download"),
          label = "OGD",
          image = icons_stzh()("external-link"),
          href = ogd_link
        )
      )
    )
  )
}

#' download Server Functions
#' @param id id of module(shiny)
#' @param filtered_data data frame with filtered data
#' @param address current address
#' @param fct_create_excel function to be called with file argument and excel args to create the excel download file
#' @noRd
mod_download_server <- function(
  id,
  filtered_data,
  address,
  fct_create_excel
) {
  stopifnot(is.reactive(filtered_data))
  stopifnot(is.reactive(address))

  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    prepped_data <- reactive(prepare_data_for_csv(filtered_data()))
    excel_args <- reactive(list(
      prepped_data(),
      address()
    ))

    fn_no_ext <- reactive(
      paste0(
        stringr::str_replace_all(address(), " ", "-"),
        "_geografische_Angaben"
      )
    )

    ## Write Download Table
    # CSV
    output$csv_download <- downloadHandler(
      filename = function() {
        paste0(fn_no_ext(), ".csv")
      },
      content = function(file) {
        write.csv(
          prepped_data(),
          file,
          fileEncoding = "UTF-8",
          row.names = FALSE,
          na = " "
        )
      }
    )

    # Excel
    output$excel_download <- downloadHandler(
      filename = function() {
        paste0(fn_no_ext(), ".xlsx")
      },
      content = function(file) {
        fct_create_excel(file, excel_args())
      }
    )
  })
}

## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1")
