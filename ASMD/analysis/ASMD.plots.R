rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
setwd("~/projects/PhoCl/ASMD/wt/dat_old")


dat1 <- read.table("all.dat", header = FALSE)
names(dat1) <- c("target", "distance", "force", "work")
dat1 <- data.frame(dat1, time = c(1:20000)*0.002, variant = "PhoCl1.0")

dat1["smooth_force"] <- NA

half.window <- 5

for (line in c(1:nrow(dat1))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat1)) {
    final <- nrow(dat1)
  }else{
    final <- line + half.window
  }
  
  dat1$smooth_force[line] <- mean(dat1$force[init:final])
}





# setwd("~/projects/PhoCl/ASMD/PhoCl2f-MV/dat_new")
# 
# 
# dat2 <- read.table("all.dat", header = FALSE)
# names(dat2) <- c("target", "distance", "force", "work")
# dat2 <- data.frame(dat2, time = c(1:17000)*0.002, variant = "PhoCl2f-MV")
# 
# dat1 <- rbind(dat1[1:17000,], dat2)

p <- ggplot(data = dat1, aes(x = time, y = distance)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time / nsec", y = "Distance") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("dist.pdf", height = 4, width = 4)


p <- ggplot(data = dat1, aes(x = time, y = force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time / nsec", y = "Force") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("force.pdf", height = 4, width = 4)


p <- ggplot(data = dat1, aes(x = time, y = smooth_force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time / nsec", y = "Force") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("smooth_force.pdf", height = 4, width = 4)

p <- ggplot(data = dat1, aes(x = time, y = work)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time / nsec", y = "Work/kJ/mol") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("work.pdf", height = 4, width = 4)


