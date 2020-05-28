
shinyServer(function(input, output, session) {

  NYC_Daycare_Clean = reactive(
    NYC_Daycare %>%
      mutate(., Inspection.month = floor_date(as.Date(clean_date_str(Inspection.Date)), 'month')) %>%
      filter(!is.na(Inspection.month), !is.na(Violation.Category), !Violation.Category == "", Violation.Category == input$Vio.Cat)
  )
  
  output$table = DT::renderDataTable({
    datatable(NYC_Daycare,
              rownames = FALSE,
              options = list(scrollX = TRUE)) %>%
      formatStyle(input$selected,
                  background = "skyblue",
                  fontWeight = 'bold')
  })
  
  output$Boro_Bar = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(., Violation.Category, Borough) %>%
      ggplot(aes(x = Borough, fill = Violation.Category)) +
      geom_bar() +
      labs(title = 'Violations by Borough',
           x = 'Borough',
           y = 'Violations') +
      scale_fill_brewer(palette = 'Set3') +
      theme_bw() +
      theme(legend.key = element_blank())
  })
  
  output$School_Type = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(., Violation.Category, Child.Care.Type) %>%
      ggplot(aes(x = Child.Care.Type, fill = Violation.Category)) +
      geom_bar(position = 'dodge') +
      labs(title = 'Violations School Type',
           x = 'Child Care Type',
           y = 'Violations') +
      scale_fill_brewer(palette = 'Set3') +
      theme_bw() +
      theme(legend.key = element_blank())
  })
  
  output$monthly_trend = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(Inspection.month) %>%
      ggplot(aes(
        x = Inspection.month,
        fill = Violation.Category,
        group = Violation.Category
      )) +
      geom_bar() +
      labs(title = 'Violation by Time',
           x = 'Time',
           y = 'Violations') +
      scale_fill_brewer(palette = 'Set3') +
      theme_bw() +
      theme(legend.key = element_blank())
  })
  
  output$Boro_Point = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(Borough, Violation.Category) %>%
      summarise(Violation.Per.Daycare.B = n() / n_distinct(Full.Address)) %>%
      ggplot(
        aes(
          x = Borough,
          y = Violation.Per.Daycare.B,
          color = Violation.Category,
          shaep = Violation.Category
        )
      ) +
      geom_point(size = 6, show.legend = TRUE) +
      labs(title = 'Violation Per Daycare by Borough',
           x = 'Borough',
           y = 'Violation Per Daycare') +
      scale_color_brewer(palette = 'Set3') +
      theme_bw() +
      theme(legend.key = element_blank())
  })
  
  output$Boro_Pie = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(Borough) %>%
      summarise(Boro_Vio = n()) %>%
      mutate(sum_Vio = sum(Boro_Vio),
             Boro_Precent = paste0(round(Boro_Vio / sum_Vio, 2))) %>%
      ggplot(aes(x = '', y = Boro_Vio, fill = Borough)) +
      geom_bar(stat = 'identity',
               width = 1,
               color = 'white') +
      coord_polar('y', start = 0) +
      geom_text(aes(label = Boro_Precent), position = position_stack(vjust = 0.5)) +
      labs(title = 'Violation Precent by Borough',
           x = '',
           y = 'Precentage %') +
      scale_fill_brewer(palette = 'Set3') +
      theme_bw() +
      theme(
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank())
  })
  
  url_me = a("https://www.linkedin.com/in/dning",
             href = "https://www.linkedin.com/in/dning")
  
  output$web_me <- renderUI({
    tagList("LinkedIn", url_me)
  })
  
  url_NYC = a(
    "https://data.cityofnewyork.us/Health/DOHMH-Childcare-Center-Inspections/dsg6-ifza",
    href = "https://data.cityofnewyork.us/Health/DOHMH-Childcare-Center-Inspections/dsg6-ifza"
  )
  
  output$web_NYC <- renderUI({
    tagList("NYC OpenData", url_NYC)
  })
  
  output$By_aycare = renderPlot({
    NYC_Daycare_Clean() %>%
      group_by(Full.Address, ZipCode) %>%
      filter(ZipCode %in% input$Zipcode) %>% 
      summarise(Vio_Per_Daycare = n())%>%
      ggplot(aes(x = Full.Address, y = Vio_Per_Daycare)) +
      geom_col(fill = 'lightblue') +
      coord_flip() +
      labs(title = 'Violation by Individual Daycares',
           x = 'Daycares',
           y = 'Violations') +
      theme_bw() +
      theme(
        panel.grid  = element_blank())
  })
  
})