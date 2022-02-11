rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
library(gapminder)
library(cowplot)
#library(tidyverse)
setwd("~/projects/PhoCl/ASMD/all/h-bond")



########################### wt ########################################

all_content <- readLines("wt.1")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl1.0", stage = 1)

dat <- df

all_content <- readLines("wt.3")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl1.0", stage = 3)

dat <- rbind(dat, df)

all_content <- readLines("wt.14")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl1.0", stage = 14)

dat <- rbind(dat, df)

############################# 2f-L ##############################
all_content <- readLines("L.1")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-L", stage = 1)

dat <- rbind(dat, df)

all_content <- readLines("L.3")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-L", stage = 3)

dat <- rbind(dat, df)

all_content <- readLines("L.14")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-L", stage = 14)

dat <- rbind(dat, df)


############################# 2f-S ##############################
all_content <- readLines("S.1")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-S", stage = 1)

dat <- rbind(dat, df)

all_content <- readLines("S.3")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-S", stage = 3)

dat <- rbind(dat, df)

all_content <- readLines("S.14")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-S", stage = 14)

dat <- rbind(dat, df)

########################### MV ########################################

all_content <- readLines("MV.1")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-MV", stage = 1)

dat <- rbind(dat, df)

all_content <- readLines("MV.3")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-MV", stage = 3)

dat <- rbind(dat, df)

all_content <- readLines("MV.14")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2f-MV", stage = 14)

dat <- rbind(dat, df)


########################### 2c ########################################

all_content <- readLines("2c.1")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2c", stage = 1)

dat <- rbind(dat, df)

all_content <- readLines("2c.3")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2c", stage = 3)

dat <- rbind(dat, df)

all_content <- readLines("2c.14")
skip <- all_content[-1]
df = read.table(textConnection(skip), header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(df, variant = "PhoCl2c", stage = 14)

dat <- rbind(dat, df)
dat$occupancy <- as.numeric(sub("%","", dat$occupancy))/100 

dat.1 <- dat %>%
  filter(stage == 1)
wide.hb.1 <- dcast(data = dat.1, donor + acceptor ~ variant, value.var = "occupancy")

dat.3 <- dat %>%
  filter(stage == 3)
wide.hb.3 <- dcast(data = dat.3, donor + acceptor ~ variant, value.var = "occupancy")

dat.14 <- dat %>%
  filter(stage == 14)
wide.hb.14 <- dcast(data = dat.14, donor + acceptor ~ variant, value.var = "occupancy")


#################################stage 1
names.bk <- names(wide.hb.1)
names(wide.hb.1) <- c("donor", "acceptor", "wt", "c", "L", "MV", "S")
wide.hb.1 <- wide.hb.1 %>%
  filter( wt > 0.2 | c > 0.2 | L > 0.2 | S > 0.2 | MV > 0.2)
wide.hb.1[is.na(wide.hb.1)] <- 0

names(wide.hb.1) <- names.bk
wide.hb.1$hb <- paste("hb1",seq(nrow(wide.hb.1)), sep = ".")

long.hb.1 <- melt(wide.hb.1[,-c(1,2)], id.vars = "hb")
# Run clustering
matrix <- as.matrix(wide.hb.1[, -c(1, 2, 8)])

dendro <- as.dendrogram(hclust(d = dist(x = matrix)))

hb.order <- order.dendrogram(dendro)


names(long.hb.1) <- c("H_bond", "Variant", "Occupancy")


long.hb.1$H_bond <- factor(x = long.hb.1$H_bond,
                             levels = rev(wide.hb.1$hb[hb.order]),
                             ordered = TRUE)

long.hb.1$Variant <- factor(x = long.hb.1$Variant,
                      levels = c("PhoCl1.0", "PhoCl2c", "PhoCl2f-S", "PhoCl2f-L", "PhoCl2f-MV"),
                      ordered = TRUE)

p1 <- ggplot(data = long.hb.1, aes(x=Variant, y=H_bond, fill=Occupancy)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "blue", limits = c(0,0.8), breaks = c(0, 0.4, 0.8)) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  theme_classic() +
  labs(y="H Bond")+
  scale_x_discrete(position = "top") +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15, angle = 90, hjust = 0), legend.position = "none")
ggsave("hb_1.pdf", p1, height = 9, width = 3)

############################# Stage 14
names.bk <- names(wide.hb.14)
names(wide.hb.14) <- c("donor", "acceptor", "wt", "c", "L", "MV", "S")
wide.hb.14 <- wide.hb.14 %>%
  filter( wt > 0.2 | c > 0.2 | L > 0.2 | S > 0.2 | MV > 0.2)
wide.hb.14[is.na(wide.hb.14)] <- 0

names(wide.hb.14) <- names.bk
wide.hb.14$hb <- paste("hb14",seq(nrow(wide.hb.14)), sep = ".")

long.hb.14 <- melt(wide.hb.14[,-c(1,2)], id.vars = "hb")
# Run clustering
matrix <- as.matrix(wide.hb.14[, -c(1, 2, 8)])

dendro <- as.dendrogram(hclust(d = dist(x = matrix)))

hb.order <- order.dendrogram(dendro)


names(long.hb.14) <- c("H_bond", "Variant", "Occupancy")


long.hb.14$H_bond <- factor(x = long.hb.14$H_bond,
                           levels = rev(wide.hb.14$hb[hb.order]),
                           ordered = TRUE)

long.hb.14$Variant <- factor(x = long.hb.14$Variant,
                            levels = c("PhoCl1.0", "PhoCl2c", "PhoCl2f-S", "PhoCl2f-L", "PhoCl2f-MV"),
                            ordered = TRUE)

p14 <- ggplot(data = long.hb.14, aes(x=Variant, y=H_bond, fill=Occupancy)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "blue", limits = c(0,0.8), breaks = c(0, 0.4, 0.8)) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  theme_classic() +
  labs(y="H Bond")+
  scale_x_discrete(position = "top") +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15, angle = 90, hjust = 0), legend.position = "none")
ggsave("hb_14.pdf", p14, height = 5.5, width = 3)

############################# Stage 2
names.bk <- names(wide.hb.3)
names(wide.hb.3) <- c("donor", "acceptor", "wt", "c", "L", "MV", "S")
wide.hb.3 <- wide.hb.3 %>%
  filter( wt > 0.2 | c > 0.2 | L > 0.2 | S > 0.2 | MV > 0.2)
wide.hb.3[is.na(wide.hb.3)] <- 0

names(wide.hb.3) <- names.bk
wide.hb.3$hb <- paste("hb3",seq(nrow(wide.hb.3)), sep = ".")

long.hb.3 <- melt(wide.hb.3[,-c(1,2)], id.vars = "hb")
# Run clustering
matrix <- as.matrix(wide.hb.3[, -c(1, 2, 8)])

dendro <- as.dendrogram(hclust(d = dist(x = matrix)))

hb.order <- order.dendrogram(dendro)


names(long.hb.3) <- c("H_bond", "Variant", "Occupancy")


long.hb.3$H_bond <- factor(x = long.hb.3$H_bond,
                            levels = rev(wide.hb.3$hb[hb.order]),
                            ordered = TRUE)

long.hb.3$Variant <- factor(x = long.hb.3$Variant,
                             levels = c("PhoCl1.0", "PhoCl2c", "PhoCl2f-S", "PhoCl2f-L", "PhoCl2f-MV"),
                             ordered = TRUE)

p3 <- ggplot(data = long.hb.3, aes(x=Variant, y=H_bond, fill=Occupancy)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "blue", limits = c(0,0.8), breaks = c(0, 0.4, 0.8)) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  theme_classic() +
  labs(y="H Bond")+
  scale_x_discrete(position = "top") +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15, angle = 90, hjust = 0), legend.position = "none")
ggsave("hb_3.pdf", p3, height = 7.5, width = 3)

pleg <- ggplot(data = long.hb.3, aes(x=Variant, y=H_bond, fill=Occupancy)) +
  geom_tile(colour = "white") +
  #scale_fill_gradient(low="white", high="blue") +
  scale_fill_gradient(low = "white", high = "blue", limits = c(0,0.8), breaks = c(0, 0.4, 0.8)) +
  #scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
  #scale_fill_distiller(palette = "YlOrRd") +
  theme_classic() +
  labs(y="H Bond")+
  scale_x_discrete(position = "top") +
  theme(text = element_text(size=23), axis.text.x = element_text(size = 15, angle = 90, hjust = 0), legend.position = "none")
ggsave("hb_3_legend.pdf", pleg, height = 7.5, width = 3)

write.csv(wide.hb.1, "hbond_stage1.csv")
write.csv(wide.hb.3, "hbond_stage3.csv")
write.csv(wide.hb.14, "hbond_stage14.csv")
