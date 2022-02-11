#     PMF.R
#      by Shuce Zhang July 6, 2020
#This script is to plot the RMSD curve
#Should you have any questions please contact Shuce: shuce@ualberta.ca

library(ggplot2)
library("plyr")
rm(list = ls())
############################Specify the parameters here#################
setwd("~/projects/ASMD/PhoCl2f-L")
df.MV <- read.table("PMF.dat", header = FALSE)
names(df.MV) <- c("Distance", "PMF")
df.MV <- data.frame(df.MV, variant="PhoCl2f-L")
#df <- data.frame(Time=df$Frame * 0.01, df, Atoms='all')
# setwd("~/projects/PhoCl/ASMD/wt")
# df.wt <- read.table("dat_new/jar.40ns.dat", header = FALSE)
# names(df.wt) <- c("Distance", "PMF")
# df.wt <- data.frame(df.wt, variant="PhoCl1")
# df.wt <- df.wt[c(1:16966),]

#df <- rbind(df.wt, df.MV)

p <- ggplot(data = df.MV, aes(x = Distance, y = PMF)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = expression(Distance/ring(A)), y = expression(PMF/kJ/mol)) +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("PMF_2f-L.pdf", height = 4, width = 4)