library(descr)

stops <- read.csv(file.choose())
freq(stops$Reason_for_Stop)
crosstab(stops$Reason_for_Stop, stops$Driver_Race, prop.c = TRUE)
investigations <- stops[which(stops$Driver_Race == "White" | stops$Driver_Race == "Black"),]
investigations <- investigations[which(investigations$Driver_Ethnicity == "Non-Hispanic"),]
investigations <- investigations[which(substr(investigations$Reason_for_Stop,0,3) == "Inv"),]
crosstab(investigations$CMPD_Division, investigations$Driver_Race, prop.r = TRUE)

summary(investigations$Reason_for_Stop)

investigations2 <- stops[which(substr(stops$Reason_for_Stop,0,3) == "Inv"),]
freq(investigations2$CMPD_Division)

