rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
library(Hmisc)
#library(tidyverse)
setwd("~/projects/PhoCl/MM-PBSA/ASMD_MM_graham")

############################# 2f-L ##############################
#PB
pbdel_wt <- read.csv("wt_15/pbdel_all.csv", header = TRUE)
pbdel_2c <- read.csv("2c/pbdel_all.csv", header = TRUE)
pbdel_L <- read.csv("2f-L/pbdel_all.csv", header = TRUE)
pbdel_S <- read.csv("2f-S/pbdel_all.csv", header = TRUE)
pbdel_LS <- read.csv("2f-LS/pbdel_all.csv", header = TRUE)
pbdel_MV <- read.csv("2f-MV/pbdel_all.csv", header = TRUE)
pbdel_MVL <- read.csv("2f-MVL/pbdel_all.csv", header = TRUE)
pbdel_MVS <- read.csv("2f-MVS/pbdel_all.csv", header = TRUE)

cMD_wt <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_15/pbdel.csv", header = TRUE)
cMD_2c <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2c/pbdel.csv", header = TRUE)
cMD_L <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-L/pbdel.csv", header = TRUE)
cMD_S <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-S/pbdel.csv", header = TRUE)
cMD_LS <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-LS/pbdel.csv", header = TRUE)
cMD_MV <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MV/pbdel.csv", header = TRUE)
cMD_MVL <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MVL/pbdel.csv", header = TRUE)
cMD_MVS <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MVS/pbdel.csv", header = TRUE)

#GB
# pbdel_wt <- read.csv("wt_21/gbdel_all.csv", header = TRUE)
# pbdel_2c <- read.csv("2c/gbdel_all.csv", header = TRUE)
# pbdel_L <- read.csv("2f-L/gbdel_all.csv", header = TRUE)
# pbdel_S <- read.csv("2f-S/gbdel_all.csv", header = TRUE)
# pbdel_LS <- read.csv("2f-LS/gbdel_all.csv", header = TRUE)
# pbdel_MV <- read.csv("2f-MV/gbdel_all.csv", header = TRUE)
# pbdel_MVL <- read.csv("2f-MVL/gbdel_all.csv", header = TRUE)
# pbdel_MVS <- read.csv("2f-MVS/gbdel_all.csv", header = TRUE)
# 
# cMD_wt <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/wt_21/gbdel.csv", header = TRUE)
# cMD_2c <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2c/gbdel.csv", header = TRUE)
# cMD_L <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-L/gbdel.csv", header = TRUE)
# cMD_S <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-S/gbdel.csv", header = TRUE)
# cMD_LS <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-LS/gbdel.csv", header = TRUE)
# cMD_MV <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MV/gbdel.csv", header = TRUE)
# cMD_MVL <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MVL/gbdel.csv", header = TRUE)
# cMD_MVS <- read.csv("~/projects/PhoCl/MM-PBSA/cMD_MM_graham/2f-MVS/gbdel.csv", header = TRUE)

addtime <- function(rawdf) {
  rawdf <- data.frame(
    Raw_frame = 25*(seq(nrow(rawdf))-1),
    Time = 0.05*(seq(nrow(rawdf))-1),
    rawdf
  )
  return(rawdf)
}

addcMD <- function(rawdf) {
  rawdf <- data.frame(
    Raw_frame = 50*(seq(nrow(rawdf))-1),
    Time = 0.5*(seq(nrow(rawdf))-1),
    rawdf,
    Stage = 0
  )
  return(rawdf)
}

pbdel_wt <- addtime(pbdel_wt)
pbdel_2c <- addtime(pbdel_2c)
pbdel_L <- addtime(pbdel_L)
pbdel_S <- addtime(pbdel_S)
pbdel_LS <- addtime(pbdel_LS)
pbdel_MV <- addtime(pbdel_MV)
pbdel_MVL <- addtime(pbdel_MVL)
pbdel_MVS <- addtime(pbdel_MVS)

cMD_wt <- addcMD(cMD_wt)
cMD_2c <- addcMD(cMD_2c)
cMD_L <- addcMD(cMD_L)
cMD_S <- addcMD(cMD_S)
cMD_LS <- addcMD(cMD_LS)
cMD_MV <- addcMD(cMD_MV)
cMD_MVL <- addcMD(cMD_MVL)
cMD_MVS <- addcMD(cMD_MVS)




################# combine ####################


pbdel <- rbind(
               data.frame(pbdel_wt, variant = "PhoCl1"),
               data.frame(pbdel_2c, variant = "PhoCl2c"),
               data.frame(pbdel_L, variant = "PhoCl2f-L"),
               data.frame(pbdel_S, variant = "PhoCl2f-S"),
               data.frame(pbdel_LS, variant = "PhoCl2f-LS"),
               data.frame(pbdel_MV, variant = "PhoCl2f-MV"),
               data.frame(pbdel_MVL, variant = "PhoCl2f-MVL"),
               data.frame(pbdel_MVS, variant = "PhoCl2f-MVS"),
               data.frame(cMD_wt, variant = "PhoCl1"),
               data.frame(cMD_2c, variant = "PhoCl2c"),
               data.frame(cMD_L, variant = "PhoCl2f-L"),
               data.frame(cMD_S, variant = "PhoCl2f-S"),
               data.frame(cMD_LS, variant = "PhoCl2f-LS"),
               data.frame(cMD_MV, variant = "PhoCl2f-MV"),
               data.frame(cMD_MVL, variant = "PhoCl2f-MVL"),
               data.frame(cMD_MVS, variant = "PhoCl2f-MVS")
               )

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

################# plotting #################################

p <- ggplot(data = pbdel, aes(x = Stage, y = DELTA.TOTAL, color = variant)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 1) +
  stat_summary(fun.data = mean_se, fun.args = list(mult=1), 
              geom="line", position = position_identity(), 
              size = 1) +
  labs(x = "Stage", y = expression(Delta~G~(kCal~mol^{-1})))+
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23))
ggsave("legend_variants.pdf", height = 4, width = 4)


# Facets
p <- ggplot(data = pbdel, aes(x = Stage, y = DELTA.TOTAL)) +
  #geom_line(aes(group=variant, color=variant)) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult=1), 
               geom="errorbar", position = position_identity(), 
               size = 1) +
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
  scale_x_continuous(breaks=seq(0,40,10), limits=c(-1,42), expand=c(0,0)) +
  scale_y_continuous(breaks=seq(-40,60,20), limits=c(-45,65), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-40, yend=60, x=-1, xend=-1, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-45, yend=-45, x=0, xend=40, lwd=0.5, colour="black", lineend="square")
  # Specify the location of your new x axis
ggsave("dG_facet_variant.pdf", height = 5, width = 8.5)


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
  scale_y_continuous(breaks=seq(-40,60,20), limits=c(-45,60), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=-40, yend=60, x=0.4, xend=0.4, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-45, yend=-45, x=1, xend=8, lwd=0.5, colour="black", lineend="square")
# Specify the location of your new x axis
ggsave("barriers_variants.pdf", height = 6, width = 6)

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
  scale_y_continuous(breaks=seq(0,100,20), limits=c(-5,100), expand=c(0,0)) +
  # Specify the breaks of y-axis
  #scale_x_continuous(breaks=seq(1950, 2010, 20), limits=c(1945,2010), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=0, yend=100, x=0.4, xend=0.4, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-5, yend=-5, x=1, xend=8, lwd=0.5, colour="black", lineend="square")
  # Specify the location of your new x axis
ggsave("Ea_variants.pdf", height = 6, width = 6)
