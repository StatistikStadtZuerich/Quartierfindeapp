#' input UI Function
#'
#' @description A shiny Module with all the inputs, returning the filtered data from the server
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param ssz_icons icon list/path which can be used
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_ui <- function(id, ssz_icons) {
  ns <- NS(id)

  # add inputs
  tagList(
    sszAutocompleteInput(
      ns("adresse"),
      "Geben Sie eine Adresse ein:",
      adressen_sorted,
      create = TRUE
    )
  )
}

#' input Server Functions
#'
#' @noRd
mod_input_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # if necessary, update one input based on the choices in another
    # with observe and bindEvent(input$...)

    # Filter main data according to inputs
    filtered_data <- reactive({
      filter_data_with_inputs(df_main, input)
    })


    return(list(
      "filtered_data" = filtered_data,
      # return some input values for appropriate naming of download
      "current_inputs" = list(
        "adresse" = reactive({
          input$adresse
        })
      )
    ))
  })
}
