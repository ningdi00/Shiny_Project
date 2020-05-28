
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
      menuItem('Reference', tabName = 'Reference', icon = icon('book'))
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
    
    tabItems(
      
      #Intro ####
      tabItem(tabName = 'Intro',
              fluidRow(
                h1('NYC Daycare Center Examination Analysis'),
                h3('"This dataset contains a list of all inspections conducted
                   and any associated violations at active, city-regulated,
                   center-based child care programs and summer camps over the past 3 years.
                   The violations are pre-adjudicated and all individual citation instances of each violation are listed." 
                   -- NYC OpenData'))
              ),
      
      #Graph ####
      tabItem(tabName = 'Graph',
              fluidRow(
                box(plotOutput('Boro_Bar')),
                box(plotOutput('Boro_Pie'), width = 3),
                box(plotOutput('Boro_Point'), width = 3)),
              fluidRow(box(plotOutput('monthly_trend')),
                       box(plotOutput('School_Type')))),
      
      #Data Table ####
      tabItem(tabName = 'Data_Table',
              fluidRow(box(DT::dataTableOutput('table'),
                           width = 12))),
      
      
      #About Me ####
      tabItem(tabName = 'Reference',
              fluidRow(
                h1('About Me: '),
                h3('Di Ning'),
                uiOutput('web_me'),
                h1(' '),
                h1('References: '),
                h3('Data Dictionary - Dataset Information'),
                h4('Dataset Name - DOHMH Childcare Center Inspections'),
                h4('Agency Name - Dataset Information'),
                h4('Update Frequency- Daily'),
                h4('Dataset Description - NYC regulated child care program inspection results'),
                h4('Dataset Keywords - Dinspections, child, health'),
                h4('Dataset Category - Health'),
                uiOutput('web_NYC')
              )
      )
    
    # violation graph by center (chain vs family owned)
    # violation graph by inspection year/month
    # violation filter by francise 
    # violation by age range
    # violation by program
    # daycares map by boro
  ))
  
  
))
