library("ape")
library("seqinr")
library("reshape2")
library("ggplot2")
library("dgof")
library("kSamples")
library("ade4")


#########################################
# Read Observed Data files


#Time-corrected data
TableD <- read.csv("TableD.csv", sep = ",", header=TRUE, fill=TRUE, check.names=FALSE)
TableD <- subset(TableD, Days1 <= 300)
TableD <- TableD[,-1]

#Data for TCMD
DataD <- read.csv("DataD_300_2.csv", sep = ",", header=TRUE, fill=TRUE, check.names=FALSE)
DataD <- DataD[,-1]

piD <- mean(TableD$modif)
piD


########################################
#Simulation files

fileNames1 <- list.files(pattern = "\\_test1.fas$")


Table1 <- numeric()
DataS1 <- vector("list")

#Calculation pairwise differences
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
  
  dMat1[,1]<-abs(as.numeric(as.character(dMat1[,1]))-as.numeric(as.character(dMat1[,3])))
  dMat1 <- dMat1[,-3]
  
  DataS1[[myFile1]] <- dMat1
  
  Table1 <- rbind(Table1, dMat1)

}


# Linear regresion
regS1<-lm(as.numeric(as.character(Table1$value)) ~ as.numeric(as.character(Table1$Days1)), data = Table1)
regS1
muS1 <- as.numeric(regS1$coefficients[2]) # slope linear regression = mutation rate

piS1 <- as.numeric(regS1$coefficients[1]) # intercept Y-axis = Pi
piS1


#Plot the 300 TCMDs in one file
png(file = "MismatchAll_300.png", width = 1500, height = 1000,  pointsize = 30)


# Calcul TCMD
##########################################################

DataS2 <- numeric()
DataS3 <- numeric()


for (i in 1:length(fileNames1)) {

  #Time-correction
  
  TablS1 <- as.data.frame(DataS1[i], col.names = "")
  TablS1 <- transform(TablS1, modif1 = round(as.numeric(as.character(value))-as.numeric(as.character(Days1))*muS1, digit = 3))
 
  #subset Tmax < 300 days
  TablS1 <- subset(TablS1, Days1 <= 300)
  
  Hist <- hist(TablS1$modif1, breaks = seq(-0.025, 0.25, by=0.002), plot=F) # interval TCMD between -0.025 and 0.25 with bin size = 0.002
  
  DataS3 <- rbind(DataS3, Hist$counts)
  
  DataS2 <- rbind(DataS2,TablS1)
  
  
  #table mismatch distribution

  mismatch1 <- data.frame(Hist$counts)
  mismatch1 <- transform(mismatch1, NbDiff = Hist$mids)
  mismatch1 <- transform(mismatch1, FreqS = round(prop.table(Hist.counts)*100, digits = 3))
  mismatch1 <- mismatch1[,-1]


  if (i==1) {
    plot(mismatch1, type="l", ylim=c(0,10), col="grey", main=expression('TCMD for '*italic(E)*' = 40, '*italic(m)*' = 0.00011 and '*italic(Kmax)*' = 50000'),
         xlab = "Time corrected pairwise differences (d)", ylab = "Frequency (%)")
    
  }
  
  lines(mismatch1, col="grey")
  

}


#Simulation

DataS <- as.numeric(apply(DataS3, 2, mean))
DataS <- transform(DataS, NbDiff = Hist$mids)
DataS <- transform(DataS, FreqS = round(prop.table(X_data)*100, digits = 3))
DataS <- DataS[,-1]


lines(DataD, col="red", lwd=2, type="s")
lines(DataS, col="black", lwd=2, type="s")

dev.off()


piS1 <- mean(DataS2$modif1)
piS1

#Plot TCMD Data vs Simulation
mismatch <- cbind(DataS, DataD)
mismatch <- mismatch[,-3]

png(file = "PlotMismatch_300_N_0.1_4.png", width = 2000, height = 1000, pointsize = 30)
p <- ggplot(mismatch, aes(NbDiff, y = value, color = Legend)) + 
  geom_step(aes(y = FreqD, col = "Neutral"), size=1) +
  geom_step(aes(y = FreqS, col = "Simulation"), size=1) +
  labs(y="Frequency (%)", x="Time corrected pairwise differences (d)") +
  #geom_vline(aes(xintercept=piS1, col="Simulation"), size=1) + 
  #geom_vline(aes(xintercept=PiD, col="Data"), size=1) +
  theme(legend.position = "right", legend.key.size = unit(2, "line"), 
        legend.text = element_text(size=30, face="bold"), legend.title = element_blank(),
        axis.title.x = element_text(face="bold", size=30, vjust = -0.5), axis.text.x  = element_text(size=30), 
        axis.title.y = element_text(face="bold", size=30, vjust = 0.5), axis.text.y  = element_text(size=30))
print(p)
dev.off()


###################################################
##Test Stat kolmogorov-smirnov

ks.test(mismatch$FreqS, mismatch$FreqD)






