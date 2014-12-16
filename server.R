library(shiny)
    generate_data <- function(row_select){
      if(row_select[,4]==row_select[,5]){
        return_data<-as.data.frame(matrix(c(as.character(row_select[,1:3]),1),ncol=4,nrow=row_select[,4],byrow=T),stringsAsFactors = F)
      }
      else if(row_select[,4]>0){	
        canc_rows<-as.data.frame(matrix(c(as.character(row_select[,1:3]),1),ncol=4,nrow=row_select[,4],byrow=T),stringsAsFactors = F)
        non_canc_rows<-as.data.frame(matrix(c(as.character(row_select[,1:3]),0),ncol=4,nrow=row_select[,5]-row_select[,4],byrow=T),stringsAsFactors = F)	
        return_data<-rbind(canc_rows,non_canc_rows)
      }
      else{return_data<-as.data.frame(matrix(c(as.character(row_select[,1:3]),0),ncol=4,nrow=row_select[,5]-row_select[,4],byrow=T),stringsAsFactors = F)}	
      return_data
    }
    new_cancer_data<-NULL
    for(i in 1:nrow(esoph)){
      new_cancer_data<-rbind(new_cancer_data,generate_data(esoph[i,]))
    }

    colnames(new_cancer_data)<-colnames(esoph)[1:4]	
    new_cancer_data[,1]<-factor(new_cancer_data[,1],levels=1:6,labels=levels(esoph[,1]))
    new_cancer_data[,2]<-factor(new_cancer_data[,2],levels=1:4,labels=levels(esoph[,2]))
    new_cancer_data[,3]<-factor(new_cancer_data[,3],levels=1:4,labels=levels(esoph[,3]))
    new_cancer_data[,4]<-factor(new_cancer_data[,4])
    esoph2<-new_cancer_data
      
    ##esoph2$ncases[esoph2$ncases>1]<-1 
    ##esoph2<-esoph2[,-5]
    levels(esoph2$alcgp)[1]<-"0-39"
    levels(esoph2$tobgp)[1]<-"0-9"

    conf<-sample(1:nrow(esoph2),size=nrow(esoph2),replace=F)
    esoph2<-esoph2[conf,]
    predictors<-c("agegp","alcgp","tobgp")
    fit<-glm(esoph2$ncases~.,data=esoph2[,predictors],family=binomial)

    PredictProb <- function(age, alc, tobgp){
                    prop <- data.frame(agegp=age, alcgp=alc, tobgp=tobgp)
                    exp(predict(fit,prop))/(1+exp(predict(fit,prop)))
                   }

##diabetesRisk <- function(glucose) glucose / 200

shinyServer(
  function(input, output) {
  output$oid1 <- renderPrint({paste(input$id1,"years")})
  output$oid2 <- renderPrint({paste(input$id2,"g/day")})
  output$oid3 <- renderPrint({paste(input$id3,"g/day")}) 
  output$prediction <- renderPrint({paste(round(100*PredictProb(age=input$id1, 
                            alc=input$id2, tobgp=input$id3),2),"%")})
  }
)