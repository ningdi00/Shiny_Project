
shinyServer(
  
  function(input, output, session){
     
    
    
     NYC_Daycare_Clean = reactive(
        NYC_Daycare %>% 
           mutate(., Inspection.month = floor_date(as.Date(clean_date_str(Inspection.Date)), 'month')) %>%
           filter(!is.na(Inspection.month), !is.na(Violation.Category), !Violation.Category == "", Violation.Category == input$Vio.Cat) 
     )
   
     output$table = DT::renderDataTable({
        datatable(NYC_Daycare, rownames = FALSE, options = list(scrollX = TRUE)) %>% 
           formatStyle(input$selected,
                       background = "skyblue",
                       fontWeight = 'bold')
     })
  
     output$Boro_Bar = renderPlot({
        NYC_Daycare_Clean() %>%
           group_by(., Violation.Category, Borough) %>%
           ggplot(aes(x = Borough, fill = Violation.Category)) +
           geom_bar() +
           labs(title = 'Violations by borough',
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
         ggplot(aes(x = Inspection.month, fill = Violation.Category, group = Violation.Category)) +
         geom_bar() +
         labs(title = 'Violation by Time',
              x = 'Time',
              y = 'Violations') +
         scale_fill_brewer(palette = 'Set3') + 
         theme_bw() +
         theme(legend.key = element_blank())
     })
   
     output$Boro_Ratio = renderPlot({
       NYC_Daycare_Clean() %>%
         group_by(Borough, Violation.Category) %>%
         summarise(Violation.Per.Daycare.B = n() / n_distinct(Full.Address)) %>%
         ggplot(aes(x = Borough, y = Violation.Per.Daycare.B, color = Violation.Category, shaep = Violation.Category)) +
         geom_point(size=6, show.legend = TRUE) +
         labs(title = 'Violation Per Daycare by Borough',
              x = 'Borough',
              y = 'Violation Per Daycare') +
         scale_fill_brewer(palette = 'Set3') +
         theme_bw() +
         theme(legend.key = element_blank())
     })
   
   
   }
 )