## delta Psi Phi heat map
rm(list = ls())
library(plyr)
library(ggplot2)
library(reshape2)
library(dplyr)
#library(tidyverse)

setwd("~/projects/PhoCl/barrel/analysis/cedar_crys_410nsec")

df <- read.table(file = "rmsd_time.txt", comment.char = '#', header = FALSE)
df[c(2:3)] <- NULL
names(df) <- c("resid", "frame", "RMSD")

df$stage <- NaN


init_frame <- 0
fin_frame <- init_frame + 9
for (stage in seq(0,400,10)) {
  
  df$stage[df$frame>=init_frame & df$frame<=fin_frame] <- stage
  
  init_frame <- init_frame + 10
  fin_frame <- init_frame + 9
}


summ_stage <- df %>%
  group_by(resid, stage) %>%
  summarise(RMSD = mean(RMSD))


############################# Stage-wise
p <- ggplot(data = summ_stage, aes(x=stage, y=resid, fill=RMSD)) +
  geom_tile() +
  scale_fill_gradient(low = "white",   high = "red", limits = c(0,30), breaks = c(0,10,20,30), name = expression(RMSD~(ring(A))))  +
  #scale_fill_distiller(palette = "OrRd", direction = 1, limits = c(0,60), breaks = c(0, 20, 40, 60), name = expression(RMSD~(ring(A)))) +
  labs(x = "Time (nsec)", y = "Residue")+
  scale_x_continuous(breaks=seq(0,400,100), limits=c(0,405), expand=c(0,0)) +
  scale_y_continuous(breaks=c(1, seq(30,210,30), 230), limits=c(1,235), expand=c(0,0)) +
  geom_segment(y=1, yend=230, x=0, xend=0, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=1, yend=1, x=0, xend=400, lwd=0.5, colour="black", lineend="square") +
  #scale_fill_distiller(palette = "YlOrRd") +
  #labs(fill = ) +
  theme_classic() +
  theme(text = element_text(size=30), 
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt"))
        #axis.text.x = element_text(size = 6,angle = 45, vjust = 0.9, hjust=0.9),


ggsave("heat_barrel_RMSD_cMD.pdf", height = 8, width = 6.5)

# 
# ############################# Frame-wise
# p <- ggplot(data = df, aes(x=frame, y=resid, fill=RMSD)) +
#   geom_tile(colour = "white") +
#   #scale_fill_gradient(low="white", high="blue") +
#   scale_fill_gradient(low = "white", high = "red", limits = c(0,60), breaks = c(0, 20, 40, 60),
#                       name = expression(RMSD~(ring(A))))+
#   scale_x_discrete(breaks=seq(0, 40, 20), limits=c(1,40), expand=c(0,0)) +
#   #scale_fill_distiller(palette = "YlOrRd") +
#   #labs(fill = ) +
#   theme_classic() +
#   theme(text = element_text(size=23), 
#         #axis.text.x = element_text(size = 6,angle = 45, vjust = 0.9, hjust=0.9),
#         legend.position = "none")
# ggsave("heat_frame_RMSD.pdf", height = 15, width = 25)
# 
