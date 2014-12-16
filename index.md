---
title       : Esophageal Cancer a Prediction Model
subtitle    : https://stsebastian.shinyapps.io/DDP_ShinyCancer/
author      : StSebastian
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [bootstrap, quiz, shiny, interactive, mathjax]            # {mathjax, quiz, bootstrap}
ext_widgets : {rCharts: [libraries/nvd3]}
mode        : selfcontained # {standalone, draft}
#knit       : slidify::knit2slides
---

## Introducing the Model

* The model estimates a person's esophageal cancer susceptibility depending on three variables:
  * age
  * tabacco consumption
  * alcohol consumption
* Calculations are based on the occurance of real esophageal cancer cases coducted in 1980 in Ille-et-Vilaine, France. The data  were  compiled by Breslow, N. E. and Day, N. E. and published by the IARC Lyon and Oxford University Press in the study: Statistical Methods in Cancer Research. 1: The Analysis of Case-Control Studies.

* In order to generate probabilities for esophageal cancer susceptibility cases a logistic regression is applied on the Breslow and Day data using age, tabacco and alcohol consumption as explenatory variables. The resulting model can be used to predict the esophageal cancer probability for different combinations of age, tabacco and alcohol consumption realizations.


--- .class #id 

## The Data

The R dataset esoph contains the relevant esophageal cancer data where the variable values are stated in categories having the following levels:

* age: 25-34, 35-44, 45-54, 55-64, 65-74, 75+
* alcohol consumption: 0-39g/day, 40-79, 80-119, 120+
* tabacco consumption: 0-9g/day, 10-19, 20-29, 30+

```
##   agegp     alcgp    tobgp ncases ncontrols
## 1 25-34 0-39g/day 0-9g/day      0        40
```
However, in the original data cancer cases are summarized for each catagory combinatios. For example ncontrols = 40 and ncases = 0 (see above) means 40 people with the respective category combinations were investigated of which none had cancer. 

In order to apply the regression the data have to be decomposed so that for each entry in the original data there are n = ncontrols entries of which m = ncases are labeled as cancer cases.


--- .class #id 

## The Regression

Having decomposed the dataset and saved in the dataframe decomp_esoph the logistic regression is conducted and the model saved in fit_esoph. 







```r
    fit_esoph <- glm (cancer ~ age + alcohol + tobacco, data = decomp_esoph, family = binomial)
```

Based on the dataset the model achieves the following accuracy:


```r
    Accuracy <- confusionMatrix (decomp_esoph$cancer, 
                as.numeric (predict (fit_esoph, decomp_esoph) > 0) ) $overall [1:4]
    Accuracy
```

```
##      Accuracy         Kappa AccuracyLower AccuracyUpper 
##     0.8276923     0.3267571     0.8024951     0.8508918
```

Which means in 83 % of all cases the model is right.

--- .class #id 

## Prediction

Predictions with the model are made in terms of the  the log odds-ratio where a value above 0 indicate a cancer probybility above 50 %.


```r
  prediction <- predict (fit_esoph,data.frame (age = "45-54", alcohol = "80-119", tobacco = "30+" ) )
  paste ("log odds-ratio",round( prediction, 3), sep=": ")
```

```
## [1] "log odds-ratio: 0.503"
```

By inverting the log odds-ratio (LOR) probabilities can be generated  
$LOR =  log(\frac{p}{1-p})$ transforms into $LOR^{-1} = \frac{exp(LOR)}{(1+exp(LOR))} = Probability$

```r
  paste ("Cancer Probability", round( exp (prediction) / (1 + exp (prediction) ), 3),sep=": " )
```

```
## [1] "Cancer Probability: 0.623"
```

