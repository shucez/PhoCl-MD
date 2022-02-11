rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
#library(tidyverse)
setwd("~/projects/PhoCl/ASMD/all")



########################### wt ########################################

dat.wt <- read.table("wt.dat", header = FALSE)
names(dat.wt) <- c("target", "distance", "force", "work")
dat.wt <- data.frame(dat.wt, time = c(1:20000)*0.002, variant = "PhoCl1.0")

dat.wt["smooth_force"] <- NA


#dat.wt <- dat.wt[dat.wt$force > -40, ]   # Filter out the outlier points, for 2f-L only!



half.window <- 5

for (line in c(1:nrow(dat.wt))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat.wt)) {
    final <- nrow(dat.wt)
  }else{
    final <- line + half.window
  }
  
  dat.wt$smooth_force[line] <- mean(dat.wt$force[init:final])
}


PMF.wt <- read.table("wt.PMF", header = FALSE)
names(PMF.wt) <- c("Distance", "PMF")
PMF.wt <- data.frame(PMF.wt, variant="PhoCl1.0")

################# combine ####################

dat <- dat.wt
PMF <- PMF.wt

################# compute stage average ###################

dat$stage <- cut(dat$time,
                 seq(0,40,1),
                 seq(1,40,1))

stage.summ <- as_tibble(dat) %>% 
  group_by(variant, stage) %>%
  summarise(force = mean(force), work = max(work))

################# ploting #################################

p <- ggplot(data = dat, aes(x = time, y = distance)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time (nsec)", y = expression(Distance~(ring(A)))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(0,43), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(0,60,20), limits=c(0,65), expand=c(0,0)) +
  geom_segment(y=0, yend=60, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=0, yend=0, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("dist_wt.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = time, y = force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time (nsec)", y = expression(Force~(kCal~mol^{-1}~ring(A)^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("force_wt.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = time, y = smooth_force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = "Time (nsec)", y = expression(Force~(kCal~mol^{-1}~ring(A)^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(0,42), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-10,30,10), limits=c(-10,32), expand=c(0,0)) +
  geom_segment(y=-10, yend=30, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-10, yend=-10, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
ggsave("smooth_force_wt.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = as.integer(stage), y = force)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
               geom="line", position = position_identity(), 
               size = 1) +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 0.6, color = "grey60") +

  labs(x = "Stage", y = expression(Force~(kCal~mol^{-1}~ring(A)^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(0,42), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(0,20,5), limits=c(0,22), expand=c(0,0)) +
  geom_segment(y=0, yend=20, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=0, yend=0, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
ggsave("force_stage_wt.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = as.integer(stage), y = work)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun = max, fun.args = list(mult=1), 
               geom="line", position = position_identity(), 
               size = 1)+
  labs(x = "Stage", y = expression(Work~(kkCal~mol^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(0,42), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(0,20,5), limits=c(0,22), expand=c(0,0)) +
  geom_segment(y=0, yend=20, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=0, yend=0, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
ggsave("work_wt.pdf", height = 4, width = 4)


p <- ggplot(data = PMF, aes(x = Distance, y = PMF)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line() +
  labs(x = expression(Distance~(ring(A))), y = expression(PMF~(kCal~mol^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,60,20), limits=c(0,62), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(0,150,50), limits=c(0,160), expand=c(0,0)) +
  geom_segment(y=0, yend=150, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=0, yend=0, x=0, xend=60, lwd=0.5, colour="black", lineend="square")
ggsave("PMF_wt.pdf", height = 4, width = 4)

