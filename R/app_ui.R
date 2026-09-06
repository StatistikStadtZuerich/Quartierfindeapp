#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  # Set the Icon path
  ogd_link <- "https://data.stadt-zuerich.ch/dataset/geo_adressen_stadt_zuerich"

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    ssz_page(
      mod_input_ui("input_1", ssz_icons),

      # Action Button and Download grouped inside .button-div
      tags$div(class = "button-div",
      sszActionButton(
        "action_button",
        "Abfrage starten"
      ),
      conditionalPanel(
        condition = "input.action_button>0",
        mod_download_ui("download_1", ogd_link)
      )),
      br(),
      br(),
      conditionalPanel(
        condition = "input.action_button>0",
        mod_results_ui("results_1"),
        uiOutput("warning")
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "sszadressengolem"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    useShinyjs(), # Include shinyjs

    # Trigger action button on Enter key in autocomplete input
    js_trigger_on_enter("input_1-adresse", "action_button")

  )
}
