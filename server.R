#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)
library(data.table)
library(cluster)
library(ggdendro)
library(DT)
library(tidyr)
library(dplyr)

pokemon <- unique(fread("pokemon.csv"))
pokemon <- pokemon[-671,]

shinyServer(function(input, output) {
    output$distPlot <- renderPlotly({
        poke<-pokemon%>%
            filter(Generation %in% c(input$tab1_gen1, input$tab1_gen2))%>%
            mutate_(Variable = input$tab1_com1)
        
        p <- ggplot(poke, aes(Variable, fill = factor(Generation))) + 
            geom_density(alpha = 0.2) +
            theme_bw() +
            ylab('Density') +
            xlab(gsub("\\."," ",input$tab1_com1))+
            ggtitle(paste(gsub("\\."," ",input$tab1_com1),"Distribution")) + 
            theme(legend.position="bottom",
                  axis.line.x = element_line(size = 0.5, colour = "black"),
                  axis.line.y = element_line(size = 0.5, colour = "black"),
                  axis.line = element_line(size=1, colour = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  plot.title=element_text(size = 20, family="xkcd"),
                  text=element_text(size = 16, family="xkcd"),
                  axis.text.x=element_text(colour="black", size = 12),
                  axis.text.y=element_text(colour="black", size = 12))
        ggplotly(p)%>%
            layout(legend = list(orientation = 'h',y = -0.085, x = 0))
        
    })
    
    output$regPlot <- renderPlotly({
        poke<- pokemon%>%
            mutate_(Variable = input$tab2_com1)%>%
            filter(Type.1 %in% input$tab2_types | Type.2 %in% input$tab2_types)
        p<- ggplot(poke, aes(factor(Generation), Variable)) + 
            geom_boxplot(fill = "#4271AE", colour = "#1F3552",alpha = 0.7) +
            geom_smooth(method = "lm", se=F, aes(group=1),colour = "red") +
            theme_bw()+
            theme(axis.line.x = element_line(size = 0.5, colour = "black"),
                  axis.line.y = element_line(size = 0.5, colour = "black"),
                  axis.line = element_line(size=1, colour = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  plot.title=element_text(size = 20, family="xkcd"),
                  text=element_text(size = 16, family="xkcd"),
                  axis.text.x=element_text(colour="black", size = 12),
                  axis.text.y=element_text(colour="black", size = 12))+
        ylab(gsub("\\."," ",input$tab2_com1)) +
            xlab('Generation')+
            ggtitle(paste(gsub("\\."," ",input$tab2_com1),"over Generations"))
        ggplotly(p)
    })
    
    output$typesPlot <- renderPlotly({
        poke<- pokemon%>%
            mutate_(Variable = input$tab3_com1)%>%
            filter(Generation %in% input$tab3_gen)%>%
            select(Variable,Type.1,Type.2)
        poke1 <- poke%>%
            filter(Type.1 == input$tab3_typ1 | Type.2 == input$tab3_typ1 )%>%
            select(Variable)%>%
            mutate(Type = input$tab3_typ1)
        poke2 <- poke%>%
            filter(Type.1 == input$tab3_typ2 | Type.2 == input$tab3_typ2 )%>%
            select(Variable)%>%
            mutate(Type = input$tab3_typ2)
        poke <- rbind(poke1,poke2)
        p <- ggplot(poke, aes(Variable, fill = factor(Type))) + 
            geom_density(alpha = 0.2) +
            theme_bw() +
            ylab('Density') +
            xlab(gsub("\\."," ",input$tab3_com1))+
            ggtitle(paste(gsub("\\."," ",input$tab1_com1),"Distribution")) + 
            theme(legend.position="bottom",
                  axis.line.x = element_line(size = 0.5, colour = "black"),
                  axis.line.y = element_line(size = 0.5, colour = "black"),
                  axis.line = element_line(size=1, colour = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  plot.title=element_text(size = 20, family="xkcd"),
                  text=element_text(size = 16, family="xkcd"),
                  axis.text.x=element_text(colour="black", size = 12),
                  axis.text.y=element_text(colour="black", size = 12))
        ggplotly(p)%>%
            layout(legend = list(orientation = 'h',y = -0.085, x = 0))
        
        
    })
    
    output$dendPlot <- renderPlot({
        
        poke<- pokemon%>%
            unique()%>%
            filter(Generation == input$tab4_gen)%>%
            gather(tmp,Type,starts_with("Type."),na.rm = TRUE)%>%
            mutate(tmp = TRUE)%>%
            spread(Type,tmp,fill = FALSE)
        
        poke<- poke %>% mutate(Attack = apply(cbind(Attack,Special.Attack), 1, max),Defense = apply(cbind(Defense,Special.Defense), 1, max))%>% select(-Special.Attack, -Special.Defense)
        rownames(poke)<- poke$Pokemon
        print(poke)
        poke<- poke%>%select(-c(1,3))
        
        
        
        hc <- hclust(dist(poke), method = "average")
        
        dendr <- dendro_data(hc, type="rectangle") 
        
        p<- ggplot() + 
            geom_segment(data=segment(dendr), aes(x=x, y=y, xend=xend, yend=yend)) + 
            geom_text(data=label(dendr), aes(x=x, y=y, label=label, hjust=0), size=3) +
            coord_flip() + scale_y_reverse(expand=c(0.2, 0)) + 
            theme(axis.line.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  axis.text.y=element_blank(),
                  axis.title.y=element_blank(),
                  panel.background=element_rect(fill="white"),
                  panel.grid=element_blank())
        print(p)
    
    }, height = 1400 )
    
    output$about <- renderUI({
        url <- a("Github", href="https://github.com/rafagurgel/Rpokemon/")
        tagList(h3("Developing Data Products Course"),
                h4("Rafael Gurgel, Feb. 2018"),
                "Source code:", url)
    })
    
    output$tab <- DT::renderDataTable({
        pokemon[,1:12]%>%
            arrange(Number)
    })
})
