# shiny-work
ui <- fixedPage(
       
     sliderInput("T",h3("temperture"),min = 200,max = 400,value = c(300)),
     sliderInput("P",h3("pressure"),min = 900,max = 1100,value = c(1000)),
          
     mainPanel(
        
         plotOutput('pl', width='70%', height='501px')
         
                     
         )
       
    )

server <- function(input, output) {

  output$pl <- renderPlot({

     # CHNOSZ/demo/saturation.R
     # first version (activity_ratios.R) 20170217
     # keep one diagram and add saturation lines 20190127
     
     ## Make equilibrium activity diagrams including saturation limits
     ## and using activity ratios as variables
     
     # The ratios are calculated with pH = 0 (activity of H+ = 1), so (activity of the ion) is equal to
     # (activity of the ion) / [(activity of H+) ^ (charge of the ion)]
     
     # NOTE: Bowers et al. use more complicated variables
     # (involving the hydration numbers of H2O and the ion)
     # with subsequently different axis ranges
     
     ## H2O-CaO-MgO-SiO2 at 300 degree C and 1000 bar
     ## Helgeson et al., 1969, p. 136 (http://www.worldcat.org/oclc/902423149)
     ## Bowers et al., 1984, p. 246 (http://www.worldcat.org/oclc/224591948)
     par(cex = 1.4)
     basis(c("H2O", "carbon dioxide", "Ca+2", "Mg+2", "SiO2", "O2", "H+"))
     species(c("quartz", "talc", "chrysotile", "forsterite", "tremolite",
               "diopside", "wollastonite", "monticellite", "merwinite"))
     # calculate the chemical affinities of formation reactions
     a <- affinity("Mg+2" = c(4, 10, 500), "Ca+2" = c(5, 15, 500), T = input$T, P = input$P)
     diagram(a, xlab = ratlab("Mg+2"), ylab = ratlab("Ca+2"), fill = "terrain", yline = 1.7)
     
     # add saturation limits for specified CO2 fugacity
     basis("CO2", -1)
     species(delete = TRUE)
     species(c("calcite", "dolomite", "magnesite", "brucite"))
     a <- affinity("Mg+2" = c(4, 10, 500), "Ca+2" = c(5, 15, 500), T = input$T, P = input$P)
     diagram(a, type = "saturation", add = TRUE, contour.method = c("edge", "edge", "flattest", "flattest"), lty = 2, cex = 1.4, col = "blue3")
     
     # add title and legend
     title(main = syslab(c("H2O", "CO2", "CaO", "MgO", "SiO2")))
     dprop <- describe.property(c("T", "P"), c(input$T, input$P))
     dbasis <- describe.basis(ibasis = 2)
     legend("bottomright", c(dprop, dbasis), bty = "n", cex = 0.9)                   
     })    
     } 
     shinyApp(ui = ui, server = server)
