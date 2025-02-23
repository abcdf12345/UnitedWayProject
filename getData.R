# Note: See https://censusreporter.org for a listing of ACS tables. For a tutorial on the

# acs package, see https://rpubs.com/rosenblum_jeff/censustutorial1. The CPS data was

# downloaded from https://cps.ipums.org.



# Set up

setwd("~/Desktop/drake/STAT172/final_project")

library(acs)



# API key

api.key.install(key="4a6312d77db109879039890c413e71c845d9c3ee")



# Get ACS data

myendyear <- 2019

myspan <- 5

geo.lookup(state="IA")

mygeo <- geo.make(state=19, county="*", tract="*", block.group="*")

mytable1 <- acs.lookup(endyear=2015, table.number="B01001") # Use 2015 just for a "look up" year

mytable2 <- acs.lookup(endyear=2015, table.number="B25010")

mytable3 <- acs.lookup(endyear=2015, table.number="B03003")

mytable4 <- acs.lookup(endyear=2015, table.number="B02001")

mytable5 <- acs.lookup(endyear=2015, table.number="B15003")

mytable6 <- acs.lookup(endyear=2015, table.number="B23025")

mytable7 <- acs.lookup(endyear=2015, table.number="B12001")

mytable8 <- acs.lookup(endyear=2015, table.number="B22010")

myvars <- mytable1[c(1,3:6,20:30,44:49)] + mytable2[1] + mytable3[3] +
  
  mytable4[3] + mytable5[21:25] + mytable6[c(4,6)] + mytable7[c(4,13)] + mytable8[c(3,6)]

mydata <- acs.fetch(endyear=myendyear, span=myspan, geography=mygeo, variable=myvars)

acs <- data.frame(GEOID = paste0(str_pad(mydata@geography$state, 2, "left", pad="0"),
                                 
                                 str_pad(mydata@geography$county, 3, "left", pad="0"),
                                 
                                 str_pad(mydata@geography$tract, 6, "left", pad="0")),
                  
                  mydata@estimate)

acs$kids <- rowSums(acs[,c("B01001_003","B01001_004","B01001_005","B01001_006",
                           
                           "B01001_027","B01001_028","B01001_029","B01001_030")])

acs$elderly <- rowSums(acs[,c("B01001_020","B01001_021","B01001_022","B01001_023",
                              
                              "B01001_024","B01001_025","B01001_044","B01001_045","B01001_046","B01001_047",
                              
                              "B01001_048","B01001_049")])

acs$education <- rowSums(acs[,c("B15003_021","B15003_022","B15003_023","B15003_024",
                                
                                "B15003_025")])

acs$employed <- rowSums(acs[,c("B23025_004","B23025_006")])

acs$married <- rowSums(acs[,c("B12001_004","B12001_013")])

acs$disability <- rowSums(acs[,c("B22010_003","B22010_006")])

acs <- acs[,c("GEOID","B01001_001","B01001_026","B25010_001","B03003_003","B02001_003",
              
              "kids","elderly","education","employed","married","disability")]

colnames(acs) <- c("GEOID","population", "female", "avg_hhsize","hispanic","black","kids",
                   
                   "elderly","education","employed","married","disability")

acs$households <- acs$population/acs$avg_hhsize

write.csv(acs, "acs(clean).csv")

