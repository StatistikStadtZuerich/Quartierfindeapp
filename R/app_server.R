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
  hide("results_1-title")
  hide("results_1-table_main")
  hide("results_1-additional")
  hide("results_1-toggle_additional_info")
  hide("download_1-downloadWrapperId")

  # Observe the action button and call module servers
  observeEvent(input$action_button, {
    # update label of action button
    updateActionButton(
      session,
      "action_button",
      label = "Erneute Abfrage"
    )

    adresse_value <- filtered_input$current_inputs$adresse()
    filtered_data <- filtered_input$filtered_data()
    # Validate address (non-empty AND filtered_data has rows)
    if (nrow(filtered_data) > 0) {
      # Hide warning UI / Show results UI
      hide("warning")
      show("results_1-title")
      show("results_1-table_main")
      show("results_1-additional")
      show("results_1-toggle_additional_info")
      show("download_1-downloadWrapperId")

      # Call modules
      mod_results_server(
        "results_1",
        filtered_data = filtered_data
      )

      prepped_data <- prepare_data_for_csv(filtered_data)

      mod_download_server(
        id = "download_1",
        data_download = prepped_data,
        fn_no_ext = paste0(adresse_value, "_geografische_Angaben"),
        fct_create_excel = create_excel,
        excel_args = list(prepped_data, adresse_value)
      )
    } else { # address is not valid
      show("warning")
      hide("results_1-title")
      hide("results_1-table_main")
      hide("results_1-additional")
      hide("results_1-toggle_additional_info")
      hide("download_1-downloadWrapperId")

      # Render a warning message when address is invalid
      output$warning <- renderUI({
        sszWarningBox(
          title = "Ungültige Adresseingabe",
          text = paste0("Die Adresse «", adresse_value, "» existiert nicht."),
          icon = ssz_icons()("important-warning-filled")
        )
      })
    }
  })
}
