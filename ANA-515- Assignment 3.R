library(tidyverse)
library(readr)
library(dplyr)
mydata <- read_csv("StormEvents_details-ftp_v1.0_d1992_c20210803.csv")
view(mydata)
myvars <- c("BEGIN_DATE_TIME","END_DATE_TIME","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
newdata <- mydata[myvars]
view(newdata)
library(lubridate)
newdata <- newdata%>%
  mutate(BEGIN_DATE_TIME = dmy_hms(BEGIN_DATE_TIME))
newdata <- newdata%>%
  mutate(END_DATE_TIME = dmy_hms(END_DATE_TIME))
head(newdata)
view(newdata)
#Change state and county names to title case.
newdata$STATE <- str_to_title(newdata$STATE, locale = "en")
view(newdata)

#5
newdata<- newdata %>%
  filter(CZ_TYPE == "C") %>%
  select(-CZ_TYPE)
view(newdata)  
#6:
library(stringr)
str_pad(newdata$STATE_FIPS, width=3,side ="left", pad ="0")
newdata <-
  unite(newdata,"fips",c(STATE_FIPS,CZ_FIPS),sep = "",remove = FALSE)
view(newdata)
#7
newdata <- rename_all(newdata,tolower)
#8

  us_state_info <-data.frame(state=state.name,region=state.region,area=state.area)
view(us_state_info)

#9
Newset <- data.frame(table(newdata$state))
Newset <-rename(Newset,c("state" = "Var1"))
view(Newset)
head(Newset)
merged <- merge(x=Newset, y=us_state_info,by.x = "state",by.y = "state")
head(merged)
library(ggplot2)
Plot<- ggplot(merged,aes(x = area, y = Freq)) + geom_point(aes(color=region))+
  labs( x = "Land area in Square miles", y = " Number of Storms in 1992")

