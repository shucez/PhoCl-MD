#rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
#library(tidyverse)
setwd("~/projects/PhoCl/ASMD/all")

############################# 2f-L ##############################
dat.L <- read.table("L.dat", header = FALSE)
names(dat.L) <- c("target", "distance", "force", "work")
dat.L <- data.frame(dat.L, time = c(1:20000)*0.002, variant = "PhoCl2f-L")

dat.L["smooth_force"] <- NA


dat.L <- dat.L[dat.L$force > -40, ]   # Filter out the outlier points, for 2f-L only!


half.window <- 5

for (line in c(1:nrow(dat.L))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat.L)) {
    final <- nrow(dat.L)
  }else{
    final <- line + half.window
  }
  
  dat.L$smooth_force[line] <- mean(dat.L$force[init:final])
}

PMF.L <- read.table("L.PMF", header = FALSE)
names(PMF.L) <- c("Distance", "PMF")
PMF.L <- data.frame(PMF.L, variant="PhoCl2f-L")


############################# 2f-S ##############################
dat.S <- read.table("S.dat", header = FALSE)
names(dat.S) <- c("target", "distance", "force", "work")
dat.S <- data.frame(dat.S, time = c(1:20000)*0.002, variant = "PhoCl2f-S")

dat.S["smooth_force"] <- NA


dat.S <- dat.S[dat.S$force > -40, ]   # Filter out the outlier points, for 2f-S only!


half.window <- 5

for (line in c(1:nrow(dat.S))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat.S)) {
    final <- nrow(dat.S)
  }else{
    final <- line + half.window
  }
  
  dat.S$smooth_force[line] <- mean(dat.S$force[init:final])
}

PMF.S <- read.table("S.PMF", header = FALSE)
names(PMF.S) <- c("Distance", "PMF")
PMF.S <- data.frame(PMF.S, variant="PhoCl2f-S")

########################### MV ########################################

dat.MV <- read.table("MV.dat", header = FALSE)
names(dat.MV) <- c("target", "distance", "force", "work")
dat.MV <- data.frame(dat.MV, time = c(1:20000)*0.002, variant = "PhoCl2f-MV")

dat.MV["smooth_force"] <- NA


#dat.MV <- dat.MV[dat.MV$force > -40, ]   # Filter out the outlier points, for 2f-L only!



half.window <- 5

for (line in c(1:nrow(dat.MV))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat.MV)) {
    final <- nrow(dat.MV)
  }else{
    final <- line + half.window
  }
  
  dat.MV$smooth_force[line] <- mean(dat.MV$force[init:final])
}


PMF.MV <- read.table("MV.PMF", header = FALSE)
names(PMF.MV) <- c("Distance", "PMF")
PMF.MV <- data.frame(PMF.MV, variant="PhoCl2f-MV")

########################### 2c ########################################

dat.2c <- read.table("2c.dat", header = FALSE)
names(dat.2c) <- c("target", "distance", "force", "work")
dat.2c <- data.frame(dat.2c, time = c(1:20000)*0.002, variant = "PhoCl2c")

dat.2c["smooth_force"] <- NA


dat.2c <- dat.2c[dat.2c$force > -40, ]   # Filter out the outlier points, for 2f-L only!



half.window <- 5

for (line in c(1:nrow(dat.2c))) {
  if (line - half.window < 1) {
    init <- 1
  }else{
    init <- line - half.window
  }
  
  if (line + half.window > nrow(dat.2c)) {
    final <- nrow(dat.2c)
  }else{
    final <- line + half.window
  }
  
  dat.2c$smooth_force[line] <- mean(dat.2c$force[init:final])
}


PMF.2c <- read.table("2c.PMF", header = FALSE)
names(PMF.2c) <- c("Distance", "PMF")
PMF.2c <- data.frame(PMF.2c, variant="PhoCl2c")


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

dat <- rbind(dat.wt, dat.L, dat.S, dat.MV, dat.2c)
PMF <- rbind(PMF.wt, PMF.L, PMF.S, PMF.MV, PMF.2c)

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
  geom_line(aes(color = variant)) +
  labs(x = "Time (nsec)", y = expression(Distance(ring(A)))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("dist.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = time, y = force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line(aes(color = variant)) +
  labs(x = "Time (nsec)", y = expression(Force~(kJ~mol^{-1}~ring(A)^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("force.pdf", height = 4, width = 4)


p <- ggplot(data = dat, aes(x = time, y = smooth_force)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line(aes(color = variant)) +
  labs(x = "Time (nsec)", y = expression(Force~(kJ~mol^{-1}~ring(A)^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("smooth_force.pdf", height = 4, width = 4)

p <- ggplot(data = dat, aes(x = time, y = work)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line(aes(color = variant)) +
  labs(x = "Time (nsec)", y = expression(Work~(kJ~mol^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("work.pdf", height = 4, width = 4)


p <- ggplot(data = PMF, aes(x = Distance, y = PMF)) +
  #geom_line(aes(group=variant, color=variant)) +
  geom_line(aes(color = variant)) +
  labs(x = expression(Distance~(ring(A))), y = expression(PMF~(kJ~mol^{-1}))) +
  theme_classic() +
  scale_colour_brewer(palette = "Dark2") +
  theme(text = element_text(size=23), legend.position = "none")
ggsave("PMF.pdf", height = 4, width = 4)


new.force <- stage.summ %>%
  select(variant, stage, force)

wide.force <- dcast(data = new.force, variant ~ stage, value.var = "force")

# Run clustering
force.matrix <- as.matrix(wide.force[, -1])
rownames(force.matrix) <- wide.force$variant
force.dendro <- as.dendrogram(hclust(d = dist(x = force.matrix)))

# Create dendro
library("ggdendro")
dendro.plot <- ggdendrogram(data = force.dendro, rotate = TRUE)

# Preview the plot
print(dendro.plot)

variant.order <- order.dendrogram(force.dendro)

# exchange the first 2

variant.order <- c(4,3,5,2,1)

# reorder

stage.summ$variant <- factor(x = stage.summ$variant,
                             levels = wide.force$variant[variant.order],
                             ordered = TRUE)

p <- ggplot(data = stage.summ, aes(x=stage, y=variant, fill=work)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "blue", limits = c(0,30), breaks = c(0, 10, 20, 30),
                      name = expression(Work~(kJ~mol^{-1}))) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  #labs(fill = ) +
  theme_classic() +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15))
ggsave("heat_work.pdf", height = 2.5, width = 15)

p <- ggplot(data = stage.summ, aes(x=stage, y=variant, fill=force)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "red", limits = c(0,30), breaks = c(0, 10, 20, 30), 
                      name = expression(Force~(kJ~mol^{-1}~ring(A)^{-1}))) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  #labs(fill = expression(Force~(kJ~mol^{-1}~ring(A)^{-1})) ) +
  theme_classic() +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15))
ggsave("heat_force.pdf", height = 2.5, width = 15)