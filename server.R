library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/

  
    defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
  series <- structure(
    lapply(defaultColors, 
           function(color) { list(color=color) }),
    names = levels(data$Region)
  )
  
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    df <- data %>%
      filter(Year == input$year, Region %in% input$region) %>%
      mutate(Bubble.Size = Life.Expectancy) %>%
      select(Country.Name, Life.Expectancy,Fertility.Rate, 
             Region, Bubble.Size) %>%
      arrange(Region)
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Fertility rate vs. life expectancy, %s",
          input$year),
        series = series
      )
    )
  })
})