
shinyUI(dashboardPage(
  skin = "purple", #shiny ui skin color
  
  #header ####
  dashboardHeader(title = h4(HTML('NYC Daycare Center Examination Analysis'))),
  
  #sidebar ####
  dashboardSidebar(
    
    #sidebar menu ####
    sidebarMenu(
      menuItem('Introduction', tabName = 'Intro', icon = icon('info-circle')),
      menuItem('Graph', tabName = 'Graph', icon = icon('chart-bar')),
      menuItem('Map', tabName = 'Map', icon = icon('map')),
      menuItem('Data Table', tabName = 'Data_Table', icon = icon('database')),
      menuItem('Reference', tabName = 'Reference', icon = icon('book')),
      menuItem('About Me', tabName = 'About_Me', icon = icon('clipboard'))
      ),
    
    #sidebar Selection ####
    selectizeInput(inputId = 'Vio.Cat', 
                   label = 'Select Violation Type to Display', 
                   choice = unique(NYC_Daycare[, 'Violation.Category']),
                   multiple = TRUE,
                   selected = list('GENERAL', 'CRITICAL', 'PUBLIC HEALTH HAZARD'))
    
  ),
  
  #body ####
  dashboardBody(
    
    #Intro Tab ####
    tabItem(
      tabItem(tabName = 'Introduction',
              fluidPage(box(textOutput('text'))))
    ),
    
    #Graph Tab ####
    tabItems(
      tabItem(tabName = 'Graph',
              fluidRow(
                box(plotOutput('Boro_Bar')),
                box(plotOutput('Boro_Ratio'), width = 3)),
              fluidRow(
                box(plotOutput('monthly_trend')),
                box(plotOutput('School_Type'))
              )),
      
    #Data Table ####
    tabItem(
      tabName = 'Data_Table',
              fluidRow(box(DT::dataTableOutput('table'),
                           width = 12)))
      
      
    
    # violation graph by center (chain vs family owned)
    # violation graph by inspection year/month
    # violation filter by francise 
    # violation by age range
    # violation by program
    # daycares map by boro
  ))
  
  
))
