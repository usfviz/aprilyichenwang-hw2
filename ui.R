# The below format took a reference on the followings:
#   https://github.com/jcheng5/googleCharts
#Install:
require(devtools)
devtools::install_github("jcheng5/googleCharts")
library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years

xlim <- list(
  min = min(data$Life.Expectancy) - 2,
  max = max(data$Life.Expectancy) + 2)
ylim <- list(
  min = min(data$Fertility.Rate)-1,
  max = max(data$Fertility.Rate)+1)

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  h2("April's world data demo- fertility rate v.s. life expectancy"),
  
  googleBubbleChart("chart",
                    width="100%", height = "475px",
                    # Set the default options for this chart; they can be
                    # overridden in server.R on a per-update basis. See
                    # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                    # for option documentation.
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "Life expectancy",
                        viewWindow = xlim
                      ),
                      vAxis = list(
                        title = "Fertility rate",
                        viewWindow = ylim
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "75%"
                      ),
                      # Allow pan/zoom
                      explorer = list(),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.5, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "none"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
  ),
  fluidRow(
    shiny::column(
        width = 3,
        offset = 2,
        sliderInput("year", "Year",
                    min = 1960, max = 2014,
                    value = 1960, animate = TRUE)),
    
    shiny::column(
        width = 3,
        checkboxGroupInput(
            "region",
            label = h4("Country Name"),
            choices = list(
                "East Asia & Pacific" = "East Asia & Pacific",
                "Europe & Central Asia" = "Europe & Central Asia",
                "Latin America & Caribbean" = "Latin America & Caribbean",
                "Middle East & North America" = "Middle East & North Africa",
                "North America" = "North America",
                "South Asia" = "South Asia",
                "Sub-Saharan Africa" = "Sub-Saharan Africa"),
        selected = c('East Asia & Pacific','Europe & Central Asia')
  )))))
