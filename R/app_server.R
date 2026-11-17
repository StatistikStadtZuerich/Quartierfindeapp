#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # run input module, get filtered inputs (reactive)
  filtered_input <- mod_input_server("input_1")

  # hide stuff initially so that it does not show if an invalid address is entered
  hide("results_container")
  hide("results_container")
  hide("download_1-downloadWrapperId")

  # update necessary data from input module only with click of action button
  # bind it all once to prevent e.g. filename to change when download is
  # only triggered after input has changed without pressing the action button
  # use an observer to make sure it is evaluated at every click
  query_snapshot <- reactiveVal(NULL)
  observe({
    query_snapshot(
      list(
        adresse_value = filtered_input$current_inputs$adresse(),
        filtered_data = filtered_input$filtered_data(),
        valid_address = nrow(filtered_input$filtered_data()) > 0
      )
    )
  }) |>
    bindEvent(input$action_button)

  # is the address valid?
  valid_address <- reactive(nrow(query_snapshot()$filtered_data) > 0)
  # get the individual components out
  filtered_data <- reactive(query_snapshot()$filtered_data)
  adresse_value <- reactive(query_snapshot()$adresse_value)

  # Observe the action button and call module servers
  observeEvent(input$action_button, {
    # update label of action button
    updateActionButton(
      session,
      "action_button",
      label = "Erneute Abfrage"
    )
  })

  # Call modules
  mod_results_server(
    "results_1",
    filtered_data = filtered_data,
    valid_address
  )

  mod_download_server(
    id = "download_1",
    filtered_data = filtered_data,
    address = adresse_value,
    fct_create_excel = create_excel
  )

  # Render a warning message when address is invalid
  output$warning <- renderUI({
    if (valid_address()) {
      return(NULL)
    }
    sszWarningBox(
      title = "Ungültige Adresseingabe",
      text = paste0(
        "Die Adresse «",
        query_snapshot()$adresse_value,
        "» existiert nicht."
      ),
      icon = icons_stzh()("important-warning-filled")
    )
  })

  observe({
    toggle("warning", condition = !valid_address())
    toggle("results_container", condition = valid_address())
    toggle("download_1-downloadWrapperId", condition = valid_address())
  }) |>
    bindEvent(input$action_button)
}
