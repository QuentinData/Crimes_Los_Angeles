source(file = "global.r")
source(file = "packages.r")


# Interface utilisateur


ui <- fluidPage(
  titlePanel("Les crimes par armes à feu dans Los Angeles en 2022"),
  
  tags$head(
    tags$style(HTML("
    body {
      background-color: #f4f4f4;
    }
    .navbar {
      background-color: #333;
    }
    .navbar-brand {
      color: #fff !important;
    }
    .custom-main-panel {
      background-color: #ffffff; /* Blanc */
    }
  "))
  ),
  
  #Sidebar
  
  
  sidebarLayout(
    sidebarPanel(
      
      # Ajout d'un titre
      
      h2("Séléction des filtres", icon = icon("filter")),
      
      # Ajout des filtres sur différents critères
      
      selectInput("weaponFilter", "Filtrer par arme :", choices = unique(data$Arme), multiple = TRUE),
      selectInput("areaFilter", "Filtrer par zone :", choices = unique(data$Lieu), multiple = TRUE),
      selectInput("seasonFilter", "Filtrer par saison :", choices = unique(data$Saison), multiple = TRUE),
      selectInput("momentFilter", "Filtrer par moment :", choices = unique(data$Moment), multiple = TRUE),
      selectInput("statusFilter", "Filtrer par statut :", choices = unique(data$Etat), multiple = TRUE),
      h5("Attention, veuillez faire au moins une séléction dans chaque filtre pour mettre à jours les visuels")
      
    ),
    
    #Mainpanel
    
    mainPanel(
      class = "custom-main-panel",
      tabsetPanel(
        
        #Onglet 1
        
        tabPanel("Données Initiales", icon = icon("table"),
                 h2("Table de données initiale"),
                 tableOutput("initialDataTable")
        ),
        
        #Onglet 2
        
        tabPanel("Résumé", icon = icon("table"),
                 h2("Résumé des affaires"),
                 tableOutput("summaryTable"),
                 
                 h3("Répartition par zone"),
                 tableOutput("areaTable"),
                 
                 h3("Répartition par arme"),
                 tableOutput("weaponTable"),
                 
                 h3("Répartition par saison"),
                 tableOutput("seasonTable"),
                 
                 h3("Répartition par moment"),
                 tableOutput("momentTable")
        ),
        
        #Onglet 3
        
        tabPanel("Repartition des états", icon = icon("chart-simple"),
                 h2("Statistiques"),
                 plotOutput("percentageUnresolvedCases")
        ),
        
        #Onglet 4
        
        tabPanel("Distribution des âges", icon = icon("chart-column"),
                 h2("Répartition des sexes des victimes par zone"),
                 plotOutput("sexDistributionPlot")
        ),
        
        #Onglet 5
        
        tabPanel("Carte Interactive", icon = icon("map"),
                 h2("Carte interactive des crimes"),
                 leafletOutput("densityMap")
        )
      )
    )
  )
)



# Serveur


server <- function(input, output, session) {
  
  # Tableau de données initiales
  output$initialDataTable <- renderTable({
    data
  })
  
  # Tableau résumé
  output$summaryTable <- renderTable({
    total_affaires <- nrow(filteredData())
    summary_data <- data.frame(
      Nombre = total_affaires
    )
    summary_data
  })
  
  # Tableau de répartition par zone
  output$areaTable <- renderTable({
    total_affaires <- nrow(filteredData())
    area_data <- filteredData() %>%
      group_by(Lieu) %>%
      summarise(Nombre = n()) %>%
      arrange(desc(Nombre)) %>%
      mutate(Pourcentage = (Nombre / total_affaires) * 100)
    area_data
  })
  
  # Tableau de répartition par arme
  output$weaponTable <- renderTable({
    total_affaires <- nrow(filteredData())
    weapon_data <- filteredData() %>%
      group_by(Arme) %>%
      summarise(Nombre = n()) %>%
      arrange(desc(Nombre)) %>%
      mutate(Pourcentage = (Nombre / total_affaires) * 100)
    weapon_data
  })
  
  # Tableau de répartition par saison
  output$seasonTable <- renderTable({
    total_affaires <- nrow(filteredData())
    season_data <- filteredData() %>%
      group_by(Saison) %>%
      summarise(Nombre = n()) %>%
      arrange(desc(Nombre)) %>%
      mutate(Pourcentage = (Nombre / total_affaires) * 100)
    season_data
  })
  
  # Tableau de répartition par moment
  output$momentTable <- renderTable({
    total_affaires <- nrow(filteredData())
    moment_data <- filteredData() %>%
      group_by(Moment) %>%
      summarise(Nombre = n()) %>%
      arrange(desc(Nombre)) %>%
      mutate(Pourcentage = (Nombre / total_affaires) * 100)
    moment_data
  })
  
  filteredData <- reactive({
    # Filtrage des données en fonction des sélections
    selectedWeapon <- input$weaponFilter
    selectedArea <- input$areaFilter
    selectedSeason <- input$seasonFilter
    selectedMoment <- input$momentFilter
    selectedStatus <- input$statusFilter
    
    data %>%
      filter(Arme %in% selectedWeapon,
             Lieu %in% selectedArea,
             Saison %in% selectedSeason,
             Moment %in% selectedMoment,
             Etat %in% selectedStatus)
  })
  
  # Graphique à barres pour la répartition par état
  output$percentageUnresolvedCases <- renderPlot({
    ggplot(filteredData(), aes(x = Etat, fill = Etat)) +
      geom_bar() +
      labs(title = "Répartition des valeurs de Status.Desc",
           x = "Statut",
           y = "Nombre de cas") +
      theme_minimal()
  })
  
  # Histogramme de répartition des âges des victimes
  output$sexDistributionPlot <- renderPlot({
    ggplot(filteredData(), aes(x = Age)) +
      geom_histogram(binwidth = 5, fill = "skyblue", color = "black", alpha = 0.7) +
      labs(title = "Répartition des âges des victimes",
           x = "Âge",
           y = "Nombre de cas") +
      theme_minimal()
  })
  
  # Carte interactive
  output$densityMap <- renderLeaflet({
    heatmap_data <- filteredData() %>%
      group_by(LAT, LON) %>%
      summarize(count = n(), .groups = 'drop')
    

    if (length(heatmap_data$count) > 0) {
      # Ajustement du facteur d'échelle
      scale_factor <- max(heatmap_data$count) / 10
    } else {
      scale_factor <- 1
    }
    
    # Carte avec des cercles proportionnels à la densité et une couleur de remplissage
    leaflet() %>%
      setView(lng = mean(filteredData()$LON), lat = mean(filteredData()$LAT), zoom = 10) %>%
      addTiles() %>%
      addCircles(lng = ~LON, lat = ~LAT, radius = ~count * scale_factor, fillOpacity = 1, color = "red", fill = TRUE, data = heatmap_data)
  })
}


# Lancement de l'application Shiny
shinyApp(ui = ui, server = server)
