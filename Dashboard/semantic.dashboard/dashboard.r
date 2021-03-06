# Following Dominik Krzeminski tutorial
# https://appsilon.com/create-outstanding-dashboards-with-the-new-semantic-dashboard-package/?nabe=4825491004194816:0&utm_referrer=https%3A%2F%2Fwww.google.com%2F

library(pacman)

pacman::p_load(pacman,shiny, semantic.dashboard, ggplot2, DT,
               plotly)

ui <- dashboardPage(
  dashboardHeader(color = "blue",title = "MtCars Dashboard", inverted = TRUE),
  dashboardSidebar(
    size = "thin", color = "green",
    sidebarMenu(
      menuItem(tabName = "main", "Visualization", icon = icon("car")),
      menuItem(tabName = "extra", "Table", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      selected = 1,
      tabItem(
        h1(strong("Mtcars Dataset Visualization")),
        tabName = "main",
        fluidRow(
          box(width = 7,
              title = "Miles per gallon vs Transmission Type",
              color = "green", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotOutput("boxplot1")
              )
          ),
          box(width = 7,
              title = "Miles per gallon vs Weight",
              color = "red", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotlyOutput("dotplot1")
              )
          )
        ),
        fluidRow(
          box(width = 7,
              title = "Cars Weight Distribution (1000 lbs)",
              color = "red", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotOutput("boxplot2")
              )
          ),
          box(width = 7,
              title = "Forward Gear Type Distribution",
              color = "green", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotlyOutput("dotplot2")
              )
          )
        )
      ),
      tabItem(
        h1(strong("Mtcars Dataset Table Format")),
        tabName = "extra",
        fluidRow(
          dataTableOutput("carstable")
        )
      )
    )
  ), theme = "cerulean"
)

server <- shinyServer(function(input, output, session) {
  data("mtcars")
  colscale <- c(semantic_palette[["red"]], semantic_palette[["green"]], semantic_palette[["blue"]])
  mtcars$am <- factor(mtcars$am,levels=c(0,1),
                      labels=c("Automatic","Manual"))
  output$boxplot1 <- renderPlot({
    ggplot(mtcars, aes(x = am, y = mpg)) +
      geom_boxplot(fill = semantic_palette[["green"]]) + 
      xlab("gearbox") + ylab("Miles per gallon")
  })
  
  output$dotplot1 <- renderPlotly({
    ggplotly(ggplot(mtcars, aes(wt, mpg))
             + geom_point(aes(colour=factor(cyl), size = qsec))
             + scale_colour_manual(values = colscale)
    )
  })
  
  output$boxplot2 <- renderPlot({
    ggplot(mtcars, aes(x=wt)) + 
      geom_histogram(binwidth=1, fill = semantic_palette[["red"]])
  })
  
  output$dotplot2 <- renderPlotly({
    ggplotly(ggplot(mtcars, aes(x=gear, fill=gear)) +
               geom_bar(fill = semantic_palette[["green"]]))
  })
  
  output$carstable <- renderDataTable(mtcars)
})

shinyApp(ui, server)
head(mtcars)
