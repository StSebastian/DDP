
levels(esoph$alcgp)[1]<-"0-39"
levels(esoph$tobgp)[1]<-"0-9"

levelage <- levels(esoph$agegp)
levelalcgp <- levels(esoph$alcgp)
leveltobgp <- levels(esoph$tobgp)

shinyUI(pageWithSidebar(
  headerPanel("Cancer prediction"),

  sidebarPanel(
    h4('Enter your data'),
    p('Enter age, alcohol and tabacco consumption below to estimate 
      the danger of suffering under esophageal cancer. The panels to 
      the right summarize your entries and state the cancer probability.'), 
    selectInput("id1", "Age",
                       c("25-34" = levelage[1],
                         "35-44" = levelage[2],
                         "45-54" = levelage[3],
                         "55-64" = levelage[4],
                         "65-74" = levelage[5],
                         "75+" = levelage[6])   
                ),    
    selectInput("id2", "Alcohol consumption in g/day",
                c("0-39" = levelalcgp[1],
                  "40-79" = levelalcgp[2],
                  "80-119" = levelalcgp[3],
                  "120+" = levelalcgp[4])
    ),    
    selectInput("id3", "Tabacco consumption in g/day",
                c("0-9" = leveltobgp[1],
                  "10-19" = leveltobgp[2],
                  "20-29" = leveltobgp[3],
                  "30+" = leveltobgp[4])
    )
    ),
    mainPanel(
      h4('Age entered'),
      verbatimTextOutput("oid1"),
      h4('Alcohol Consumption entered'),
      verbatimTextOutput("oid2"),
      h4('Tabacco Consumption entered'),
      verbatimTextOutput("oid3"),
    
      h3('Medical Prediction'),
      h4('Probability of cancer case'),
      verbatimTextOutput("prediction"),
      p('The calculations are based on a case-control study of (o)esophageal cancer in 
        Ille-et-Vilaine, France. The data were published by Breslow, N. E. and Day, N. E. 
        in 1980 (Statistical Methods in Cancer Research. 1: The Analysis of Case-Control 
        Studies. IARC Lyon / Oxford University Press)')
      )
))