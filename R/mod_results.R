#' results UI Function
#'
#' @description A Shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Dynamic title  that will include the address
    uiOutput(ns("title")),

    # Main table output with primary categories
    shinycssloaders::withSpinner(
      reactableOutput(ns("table_main")),
      type = 7,
      color = "#0F05A0"
    ),
    br(),
    br(),
    uiOutput(ns("stadtplan_link")),
    uiOutput(ns("quartierspiegel_link"))
  )
}

#' results Server Function
#'
#' @param filtered_data A static data.frame with the filtered data to be shown
#'
#' @noRd
mod_results_server <- function(id, filtered_data, valid_address) {
  stopifnot(is.reactive(filtered_data))
  stopifnot(is.reactive(valid_address))
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Render dynamic title with reactive adresse value
    output$title <- renderUI({
      req(valid_address())
      tagList(
        h1(paste0(
          "Die Adresse «",
          filtered_data()$adresse,
          "» befindet sich hier:"
        ))
      )
    })

    # Render the main table with filtered data
    output$table_main <- renderReactable({
      req(valid_address())
      # Wahlkreis hinzufügen
      df_additional <- add_wahlkreis(filtered_data())
      create_main_reactable(df_additional)
    })

    output$stadtplan_link <- renderUI({
      req(valid_address())
      link_stadtplan <- build_stadtplan_url(filtered_data())
      if (!is.null(link_stadtplan)) {
        tags$p(
          tags$a(
            href = link_stadtplan,
            target = "_blank",
            "Stadtplan an dieser Adresse öffnen ",
            icons_stzh()("external-link")
          )
        )
      }
    })

    output$quartierspiegel_link <- renderUI({
      req(valid_address())
      link_quartierspiegel <- build_quartierspiegel_url(filtered_data())
      if (!is.null(link_quartierspiegel)) {
        tags$p(
          tags$a(
            href = link_quartierspiegel,
            target = "_blank",
            "Mehr zu diesem Quartier erfahren",
            icons_stzh()("external-link")
          )
        )
      }
    })
  })
}
