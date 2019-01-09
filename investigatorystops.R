library(descr)
stops <- read.csv(file.choose())

freq(stops$Reason_for_Stop)

crosstab(stops$Reason_for_Stop, 
         stops$Driver_Race,
         prop.c = TRUE)

#Get White or Black Drivers
investigations2 <- stops[which(stops$Driver_Race == "White" | stops$Driver_Race == "Black"),]
#Remove Hispanic Drivers
investigations2 <- investigations2[which(investigations2$Driver_Ethnicity == "Non-Hispanic"),]
#Pull only investigatory stops
investigations2 <- investigations2[which(substr(investigations2$Reason_for_Stop,0,3) == "Inv"),]

#Relevel No to be 0
relevel(investigations2$Was_a_Search_Conducted, "No")
#Compare Driver Race and Search Being Conducted
crosstab(investigations2$Was_a_Search_Conducted, investigations2$Driver_Race, prop.c = TRUE)

#Control for District
summary(glm(investigations2$Was_a_Search_Conducted ~ investigations2$Driver_Race + investigations2$CMPD_Division, family = "binomial"))

#Don't Control for District
summary(glm(investigations2$Was_a_Search_Conducted ~ investigations2$Driver_Race, family = "binomial"))

#Control for Driver Age
summary(glm(investigations2$Was_a_Search_Conducted ~ 
            investigations2$Driver_Age + investigations2$Driver_Race, family = "binomial"))

#GET BLACK OFFICERS AND WHITE OFFICERS
black.officers <- investigations2[which(investigations2$Officer_Race == "Black/African American"),]
white.officers <- investigations2[which(investigations2$Officer_Race == "White"),]

crosstab(white.officers$Was_a_Search_Conducted, 
         white.officers$Driver_Race, 
         prop.c = TRUE, 
         prop.chisq = TRUE, 
         chisq = TRUE)
crosstab(black.officers$Was_a_Search_Conducted, 
         black.officers$Driver_Race, 
         prop.c = TRUE, 
         prop.chisq = TRUE, 
         chisq = TRUE)


#GET SEARCHED CIVILIANS BY RACE BY OFFICERS
searched.white.officer <- white.officers[which(white.officers$Was_a_Search_Conducted == "Yes"),]
searched.black.officer <- black.officers[which(black.officers$Was_a_Search_Conducted == "Yes"),]

crosstab(searched.black.officer$Result_of_Stop, 
         searched.black.officer$Driver_Race, 
         prop.c = TRUE, 
         chisq = TRUE)
crosstab(searched.white.officer$Result_of_Stop, 
         searched.white.officer$Driver_Race, 
         prop.c = TRUE, 
         chisq = TRUE)

#LOGISTIC REGRESSION FOR LIKELIHOOD TO BE SEARCHED
summary(glm(investigations2$Was_a_Search_Conducted ~ investigations2$Officer_Gender + investigations2$Officer_Years_of_Service + investigations2$Driver_Race + investigations2$Driver_Gender + investigations2$Driver_Age, family = "binomial"))