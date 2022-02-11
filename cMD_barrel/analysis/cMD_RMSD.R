#     cMD_RMSD.R
#      by Shuce Zhang Aug 12, 2020

library(ggplot2)
library("plyr")
rm(list = ls())
############################Specify the parameters here#################
setwd("~/projects/PhoCl/barrel/analysis/cedar_crys_290nsec")



df <- read.table("rmsd_all.out", header = FALSE)
names(df) <- c("Frame", "RMSD")
df <- data.frame(Time=df$Frame * 0.1, df, variant = "Post cMD", include = "All")

dat_post <- df

df <- read.table("rmsd_nocp.out", header = FALSE)
names(df) <- c("Frame", "RMSD")
df <- data.frame(Time=df$Frame * 0.1, df, variant = "Post cMD", include = "No CP loop")

dat_post <- rbind(dat_post, df)

df <- read.table("rmsd_loop.out", header = FALSE)
names(df) <- c("Frame", "RMSD")
df <- data.frame(Time=df$Frame * 0.1, df, variant = "Post cMD", include = "201-207 loop")

dat_post <- rbind(dat_post, df)

p <- ggplot(data = dat_post, aes(x = Time, y = RMSD)) +
  geom_line(aes(group = include, color = include)) +
  labs(x = "Time/nsec", y = expression(RMSD/ring(A))) +
  theme_classic() +
  #scale_colour_brewer(palette = "Dark2", labels = c("All", "No cp-loop")) +
  scale_color_discrete(name = "Include")+
  theme(text = element_text(size=30), legend.position = "none", # make texts larger,
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt"),
        axis.text = element_text(size = 20)) +
  scale_y_continuous(breaks=seq(0,10,5), limits=c(-0.2,10.2), expand=c(0,0)) +
  # Specify the breaks of y-axis
  scale_x_continuous(breaks=seq(0, 300, 100), limits=c(-30,330), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=0, yend=10, x=-30, xend=-30, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-0.2, yend=-0.2, x=0, xend=300, lwd=0.5, colour="black", lineend="square")

ggsave("post_cMD_RMSD.pdf", height = 4, width = 4.5)

p <- ggplot(data = dat_post, aes(x = Time, y = RMSD)) +
  geom_line(aes(group = include, color = include)) +
  labs(x = "Time/nsec", y = expression(RMSD/ring(A))) +
  theme_classic() +
  #scale_colour_brewer(palette = "Dark2", labels = c("All", "No cp-loop")) +
  scale_color_discrete(name = "Include")+
  theme(text = element_text(size=30), legend.position = "none", # make texts larger,
        axis.line = element_blank(),    # hide the default axes
        axis.ticks.length = unit(7,"pt"),
        axis.text = element_text(size = 20)) +
  scale_y_continuous(breaks=seq(0,10,5), limits=c(-0.2,10.2), expand=c(0,0)) +
  # Specify the breaks of y-axis
  scale_x_continuous(breaks=seq(200, 210, 5), limits=c(199,211), expand=c(0,0)) +
  # Specify the breaks of x-axis
  geom_segment(y=0, yend=10, x=199, xend=199, lwd=0.5, colour="black", lineend="square") +
  # Specify the location of your new y-axis
  geom_segment(y=-0.2, yend=-0.2, x=200, xend=210, lwd=0.5, colour="black", lineend="square")

ggsave("post_cMD_RMSD_zoom.pdf", height = 4, width = 4.5)


# p <- ggplot(data = dat, aes(x = Time, y = RMSD)) +
#   #geom_line(aes(group=variant, color=variant)) +
#   facet_wrap(~variant) +
#   geom_line(aes(group = include, color = include)) +
#   labs(x = "Time/nsec", y = expression(RMSD/ring(A))) +
#   theme_classic() +
#   #scale_colour_brewer(palette = "Dark2", labels = c("All", "No cp-loop")) +
#   #scale_color_discrete(name = "Include", labels = c("All", "No cp-loop"))+
#   theme(text = element_text(size=30), legend.position = c(0.85,0.2), # make texts larger,
#         axis.line = element_blank(),    # hide the default axes
#         axis.ticks.length = unit(7,"pt"),
#         axis.text = element_text(size = 20)) +
#   scale_y_continuous(breaks=seq(0,10,5), limits=c(-0.2,10.2), expand=c(0,0)) +
#   # Specify the breaks of y-axis
#   scale_x_continuous(breaks=seq(0, 200, 100), limits=c(-20,230), expand=c(0,0)) +
#   # Specify the breaks of x-axis
#   geom_segment(y=0, yend=10, x=-20, xend=-20, lwd=0.5, colour="black", lineend="square") +
#   # Specify the location of your new y-axis
#   geom_segment(y=-0.2, yend=-0.2, x=0, xend=200, lwd=0.5, colour="black", lineend="square")
# # Specify the location of your new x axis
# ggsave("cMD_RMSD.pdf", height = 6, width = 8)
  