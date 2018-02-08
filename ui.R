#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(plotly)
library(shiny)

pokemon.types <- c("Bug",
                   "Dark",
                   "Dragon",
                   "Electric",
                   "Fairy",
                   "Fighting",
                   "Fire",
                   "Flying",
                   "Ghost",
                   "Grass",
                   "Ground",
                   "Ice",
                   "Normal",
                   "Poison",
                   "Psychic",
                   "Rock",
                   "Steel",
                   "Water")
# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Pokemon View",
                   tabPanel("Generations Comparison",
                            titlePanel("Generations Comparison"),
                            sidebarLayout(
                                sidebarPanel(
                                    fluidRow(selectInput('tab1_gen1', 
                                                         'Select Generation', 
                                                         c("Generation 1" = 1,
                                                           "Generation 2" = 2,
                                                           "Generation 3" = 3,
                                                           "Generation 4" = 4,
                                                           "Generation 5" = 5,
                                                           "Generation 6" = 6,
                                                           "Generation 7" = 7), 
                                                         selectize=TRUE,
                                                         selected = 1),
                                             includeCSS("mystyle.css"),
                                             selectInput('tab1_gen2', 
                                                         'Select Generation', 
                                                         c("Generation 1" = 1,
                                                           "Generation 2" = 2,
                                                           "Generation 3" = 3,
                                                           "Generation 4" = 4,
                                                           "Generation 5" = 5,
                                                           "Generation 6" = 6,
                                                           "Generation 7" = 7), 
                                                         selectize=TRUE,
                                                         selected = 2),
                                             
                                             selectInput('tab1_com1',
                                                         'Attribute',
                                                         c("Total", 
                                                           "HP", 
                                                           "Attack", 
                                                           "Defense", 
                                                           "Special Attack" = "Special.Attack", 
                                                           "Special Defense" = "Special.Defense", 
                                                           "Speed"),
                                                         selectize=TRUE)
                                        )
                                    
                                    
                                    
                                ),
                                
                                # Show a plot of the generated distribution
                                mainPanel(
                                    plotlyOutput("distPlot")
                                )
                            )
                            ),
                   tabPanel("Generations Progression",
                            titlePanel("Generations Progression"),
                            sidebarLayout(
                                sidebarPanel(selectInput('tab2_com1',
                                                         'Attribute',
                                                         c("Total", 
                                                           "HP", 
                                                           "Attack", 
                                                           "Defense", 
                                                           "Special Attack" = "Special.Attack", 
                                                           "Special Defense" = "Special.Defense", 
                                                           "Speed"),
                                                         selectize=TRUE),
                                             checkboxGroupInput("tab2_types", "Types",
                                                                choices = pokemon.types,
                                                                selected = pokemon.types
                                                                )
                                    ),
                                mainPanel(
                                    plotlyOutput("regPlot")
                                )
                                )
                            ),
                   tabPanel("Types Comparison",
                            titlePanel("Types Comparison"),
                            sidebarLayout(
                                sidebarPanel(
                                    selectInput('tab3_typ1',
                                                'Select Type',
                                                pokemon.types,
                                                selectize=TRUE,
                                                selected = 'Fire'),
                                    selectInput('tab3_typ2',
                                                'Select Type',
                                                pokemon.types,
                                                selectize=TRUE,
                                                selected = 'Water'),
                                    selectInput('tab3_com1',
                                                         'Attribute',
                                                         c("Total", 
                                                           "HP", 
                                                           "Attack", 
                                                           "Defense", 
                                                           "Special Attack" = "Special.Attack", 
                                                           "Special Defense" = "Special.Defense", 
                                                           "Speed"),
                                                         selectize=TRUE),
                                    
                                     checkboxGroupInput("tab3_gen", "Generation",
                                                        choices = c("Generation 1" = 1,
                                                                    "Generation 2" = 2,
                                                                    "Generation 3" = 3,
                                                                    "Generation 4" = 4,
                                                                    "Generation 5" = 5,
                                                                    "Generation 6" = 6,
                                                                    "Generation 7" = 7),
                                                        selected = 1:7
                                             )
                                ),
                                mainPanel(
                                    plotlyOutput("typesPlot")
                                )
                            )
                            
                            
                            ),
                   tabPanel("Cluster Analysis",
                            titlePanel("Cluster Analysis"),
                            sidebarLayout(
                                sidebarPanel(
                                    selectInput('tab4_gen', 
                                                'Select Generation', 
                                                c("Generation 1" = 1,
                                                  "Generation 2" = 2,
                                                  "Generation 3" = 3,
                                                  "Generation 4" = 4,
                                                  "Generation 5" = 5,
                                                  "Generation 6" = 6,
                                                  "Generation 7" = 7), 
                                                selectize=TRUE,
                                                selected = 1)
                                ),
                                mainPanel(
                                    plotOutput("dendPlot")
                                )
                            )),
               
               tabPanel("Dataset",
                        titlePanel("Dataset"),
                            mainPanel(
                                DT::dataTableOutput("tab")
                            )
                        ),
                   
                   tabPanel("About",
                            titlePanel("About"),
                                mainPanel(
                                    uiOutput("about")
                                )
                            )
               
               
                   

  # Application title
))
