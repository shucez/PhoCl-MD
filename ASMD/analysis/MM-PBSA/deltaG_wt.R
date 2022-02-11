rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
library(Hmisc)
#library(tidyverse)
setwd("~/projects/PhoCl/MM-PBSA/ASMD_MM_graham")

##PBSA
pbdel_15 <- read.csv("wt_15/pbdel_all.csv", header = TRUE)
pbdel_20 <- read.csv("wt_20/pbdel_all.csv", header = TRUE)
pbdel_21 <- read.csv("wt_21/pbdel_all.csv", header = TRUE)

cMD_15 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_15/pbdel.csv", header = TRUE)
cMD_20 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_20/pbdel.csv", header = TRUE)
cMD_21 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_21/pbdel.csv", header = TRUE)

#GBSA
# pbdel_15 <- read.csv("wt_15/gbdel_all.csv", header = TRUE)
# pbdel_20 <- read.csv("wt_20/gbdel_all.csv", header = TRUE)
# pbdel_21 <- read.csv("wt_21/gbdel_all.csv", header = TRUE)
# 
# cMD_15 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_15/gbdel.csv", header = TRUE)
# cMD_20 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_20/gbdel.csv", header = TRUE)
# cMD_21 <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_21/gbdel.csv", header = TRUE)


addtime <- function(rawdf) {
  rawdf <- data.frame(
    Raw_frame = 50*(seq(nrow(rawdf))-1),
    Time = 0.05*(seq(nrow(rawdf))-1),
    rawdf
  )
  return(rawdf)
}

pbdel_15 <- addtime(pbdel_15)
pbdel_20 <- addtime(pbdel_20)
pbdel_21 <- addtime(pbdel_21)

addcMD <- function(rawdf) {
  rawdf <- data.frame(
    Raw_frame = 50*(seq(nrow(rawdf))-1),
    Time = 0.5*(seq(nrow(rawdf))-1),
    rawdf,
    Stage = 0
  )
  return(rawdf)
}

cMD_15 <- addcMD(cMD_15)
cMD_20 <- addcMD(cMD_20)
cMD_21 <- addcMD(cMD_21)


################# combine ####################


pbdel <- rbind(
               data.frame(pbdel_15, variant = "Rep1"),
               data.frame(pbdel_20, variant = "Rep2"),
               data.frame(pbdel_21, variant = "Rep3"),
               data.frame(cMD_15, variant = "Rep1"),
               data.frame(cMD_20, variant = "Rep2"),
               data.frame(cMD_21, variant = "Rep3"))
               


summ_delG <- as_tibble(pbdel) %>%
  group_by(variant, Stage) %>%
  summarise(Mean = mean(DELTA.TOTAL), Sd = sd(DELTA.TOTAL))

barriers <- summ_delG %>% 
  group_by(variant) %>% 
  filter(Mean == max(Mean))

start <- summ_delG %>% 
  group_by(variant) %>% 
  filter(Stage == 0)

summ.Ea <- merge(start, barriers, by.x = "variant", by.y = "variant") %>%
  mutate(Ea = Mean.y - Mean.x,
         Sd.Ea = sqrt(Sd.x^2 + Sd.y^2))

Ea.long.1 <- data.frame(summ.Ea[c(1,3:4)],
                        Stage = "Initial")
names(Ea.long.1) <- c("variant", "Energy", "Sd", "Stage")
Ea.long.2 <- data.frame(summ.Ea[c(1,6:7)],
                        Stage = "Barrier")
names(Ea.long.2) <- c("variant", "Energy", "Sd", "Stage")

Ea.long.3 <- data.frame(summ.Ea[c(1,8:9)],
                        Stage = "Ea")
names(Ea.long.3) <- c("variant", "Energy", "Sd", "Stage")

Ea.long <- rbind(Ea.long.1, Ea.long.2, Ea.long.3)



################# ploting #################################

p <- ggplot(data = pbdel, aes(x = Stage, y = DELTA.TOTAL, color = variant)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 1) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult=1), 
              geom="line", position = position_identity(), 
              size = 1) +
  labs(x = "Stage", y = expression(Delta~G~(kCal~mol^{-1})))+
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(-1,40), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-20,60,20), limits=c(-25,41), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-20, yend=40, x=-1, xend=-1, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-25, yend=-25, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("delG_wt.pdf", height = 4, width = 5.5)

# Facets
p <- ggplot(data = pbdel, aes(x = Stage, y = DELTA.TOTAL)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 0.3, alpha = 0.4) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult=1), 
               geom="line", position = position_identity(), 
               size = 1) +
  facet_wrap(vars(variant), nrow = 2, ncol = 4) +
  labs(x = "Stage", y = expression(Delta~G~(kCal~mol^{-1})))+
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=19),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(-1,41), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-20,60,20), limits=c(-25,41), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-20, yend=40, x=-1, xend=-1, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-25, yend=-25, x=0, xend=42, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("dG_facet_wt_0.pdf", height = 3, width = 6.5)

p <- ggplot(data = pbdel[pbdel$variant == "Rep3",], aes(x = Stage, y = DELTA.TOTAL)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 0.6, color = "grey60") +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
               geom="line", position = position_identity(), 
               size = 1) +
  labs(x = "Stage", y = expression(Delta~G~(kCal~mol^{-1})))+
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt")) +
  scale_x_continuous(breaks=seq(0,40,10), limits=c(0,42), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-20,40,20), limits=c(-20,43), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-20, yend=40, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-20, yend=-20, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("dG_wt21_0.pdf", height = 4, width = 4)


p <- ggplot(data = Ea.long[Ea.long$Stage != "Ea",], 
            aes(x = variant, y = Energy, color = Stage)) +
  # geom_jitter(position = position_jitterdodge(0.4), alpha = 0.5) +
  # stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), 
  #              geom="errorbar", width=0.3, position = position_dodge(0.7), size = 1) +
  # stat_summary(fun=mean, geom="point", position = position_dodge(0.7), size = 3) +
  geom_point(position = position_identity()) +
  geom_errorbar(aes(ymin = Energy - Sd, ymax = Energy + Sd), width=0.5) +
  labs(x = "Variant", y = expression(Ea~(kCal~mol^{-1})))+
  theme_classic() +
  # scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt"),
        axis.text.x = element_text(angle = 45, vjust = 0.9, hjust=0.9)) +
  scale_y_continuous(breaks=seq(-20,40,20), limits=c(-30,45), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-20, yend=40, x=0.4, xend=0.4, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-30, yend=-30, x=1, xend=3, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("barriers_wt_0.pdf", height = 4, width = 4.5)

p <- ggplot(data = Ea.long[Ea.long$Stage == "Ea",], 
            aes(x = variant, y = Energy)) +
  # geom_jitter(position = position_jitterdodge(0.4), alpha = 0.5) +
  # stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), 
  #              geom="errorbar", width=0.3, position = position_dodge(0.7), size = 1) +
  # stat_summary(fun=mean, geom="point", position = position_dodge(0.7), size = 3) +
  geom_col(position = position_identity()) +
  geom_errorbar(aes(ymin = Energy - Sd, ymax = Energy + Sd), width=0.5) +
  labs(x = "Variant", y = expression(Ea~(kCal~mol^{-1})))+
  theme_classic() +
  # scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23),
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt"),
        axis.text.x = element_text(angle = 45, vjust = 0.9, hjust=0.9)) +
  scale_y_continuous(breaks=seq(0,50,10), limits=c(-5,55), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=0, yend=50, x=0.4, xend=0.4, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-5, yend=-5, x=1, xend=3, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("Ea_wt_0.pdf", height = 4, width = 4)
