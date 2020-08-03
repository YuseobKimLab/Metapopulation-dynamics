library("ape")
library("seqinr")
library("reshape2")


fileNames1 <- list.files(pattern = "\\_test1.fas$")

Table1 <- numeric()
DataS1 <- vector("list")


#Read sequence files and calculation pairwise differences and time differences

for (myFile1 in fileNames1) {
  dMat1 <- dist.dna(read.dna(myFile1, format = "fasta"), model = "raw", variance = FALSE, 
                    gamma = FALSE, pairwise.deletion = FALSE, base.freq = NULL, as.matrix = TRUE)
  
  dMat1[upper.tri(dMat1, diag = TRUE)] <- NA
  dMat1 <- melt(dMat1)
  dMat1 <- as.data.frame(dMat1)
  dMat1 <- subset(dMat1, dMat1[3] != "")
  
  dMat1 <- separate(dMat1, Var1, into=c("Days1", "Deme1"),sep="_" )
  dMat1 <- separate(dMat1, Var2, into=c("Days2", "Deme2"),sep="_" )
  dMat1 <- as.data.frame(lapply(dMat1, gsub, pattern='d', replacement=''))
  

  dMat1[,6]<-abs(as.numeric(as.character(dMat1[,1]))-as.numeric(as.character(dMat1[,3])))

  DataS1[[myFile1]] <- dMat1

  Table1 <- rbind(Table1, dMat1)
  }


# Linear regression
regS1<-lm(as.numeric(as.character(Table1$value)) ~ as.numeric(as.character(Table1$V6)), data = Table1)
regS1
muS1 <- as.numeric(regS1$coefficients[2]) # slope of the linear regression = mutation rate



#Calculation statistics for the 300 files

DataS2 <- numeric()
DataS3 <- numeric()


PiD_300 <- numeric()
PisD_300 <- numeric()
PiTD_300 <- numeric()
FstD_300 <- numeric()


for (i in 1:length(fileNames1)) {

# Calculation time correction
##########################################################
Table1 <- as.data.frame(DataS1[i], col.names = "")
TableS1 <- transform(Table1, modif = round(as.numeric(as.character(value))-as.numeric(as.character(V6))*muS1, digit = 3))

TableS1 <- transform(TableS1, Days1=as.numeric(as.character(TableS1$Days1)), Days2=as.numeric(as.character(TableS1$Days2)))


#########################################################
#Subset time difference inferior to 300 days

TableS11 <- subset(TableS1, V6 <= 300)


#Calcul Fst
#########################################################

D1 <- unique(TableS11$Deme1) #valeurs dans Deme
L1 <- length(unique(TableS11$Deme1)) #nombres de Demes


##################################

#Calculation mean Pi

piD <- mean(TableS11$modif)
piD

PiD_300 <- rbind(PiD_300, piD) # mean pi for each of the 300 simulated files


#calculation PiS

DataD1 <- as.numeric()

for (i in D1){
  meanD1 <- mean(TableS11$modif[TableS11$Deme1 == i & TableS11$Deme2 == i])
  DataD1 <- rbind(DataD1, meanD1)
}

DataD1

PisD <- sum(DataD1)/length(unlist(DataD1))
PisD

PisD_300 <- rbind(PisD_300, PisD)


#Calculation de PiT

DataD2 <- as.numeric()

for (i in D1){
  for (j in D1){
    meanD2 <- mean(TableS11$modif[TableS11$Deme1 == i & TableS11$Deme2 != i & TableS11$Deme2 == j | 
                                  TableS11$Deme1 == j & TableS11$Deme2 != j & TableS11$Deme2 == i])
    
    DataD2 <- rbind(DataD2, meanD2)
  }
}

DataD2 <- unique(DataD2)
DataD2 <- as.data.frame(DataD2[complete.cases(DataD2), ])


PiTD <- (sum(DataD1)+sum(2*DataD2))/(length(unlist(DataD2))*2+length(unlist(DataD1)))
PiTD

PiTD_300 <- rbind(PiTD_300, PiTD)

#Calcul Fst

FstD <- 1-(PisD/PiTD)
FstD

FstD_300 <- rbind(FstD_300, FstD)

}

#############################################
#Mean of Fst and Pi of the 300 files

meanFst_300 <- mean(FstD_300[,1])
meanFst_300

meanPi_300 <- mean(PiD_300[,1])
meanPi_300



rm(list = ls())
