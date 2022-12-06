#!/usr/bin/env Rscript

library(tidyverse)
library(ggbeeswarm)
library(gridExtra)

args <- commandArgs(trailingOnly = T)

odgi_layout_csv <- args[1]
odgi_draw_csv <- args[2]
BandageNG_csv <- args[3]
Bandage_csv <- args[4]
# gfaviz_csv <- args[5]
layout_pdf <- args[5]
layout_csv <- args[6]

time_to_seconds <- function(time_vec) {
  for (i in 1:length(time_vec)) {
    t <- time_vec[i]
    time_split <- strsplit(t, ":")[[1]]
    if (length(time_split) == 2) {
      time_vec[i] = as.numeric(time_split[1]) * 60 + as.numeric(time_split[2])
    } else {
      time_vec[i] = as.numeric(time_split[1]) * 3600 + as.numeric(time_split[2]) * 60 + as.numeric(time_split[3])
    }
  }
  return(time_vec)
}

#odgi_layout_csv <- "/home/heumos/Downloads/hogwild_paper/odgi/odgi_layout_time.csv"
odgi_layout <- read.delim(odgi_layout_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(odgi_layout) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
odgi_layout$tool <- "odgi layout"
odgi_layout$time <- as.numeric(time_to_seconds(odgi_layout$time))
summary(odgi_layout)

#odgi_draw_csv <- "/home/heumos/Downloads/hogwild_paper/odgi/odgi_draw_time.csv"
odgi_draw <- read.delim(odgi_draw_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(odgi_draw) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
odgi_draw$tool <- "odgi draw"
odgi_draw$time <- as.numeric(time_to_seconds(odgi_draw$time))
summary(odgi_draw)

odgi <- odgi_layout
for (i in 1:dim(odgi_layout)[1]) {
  odgi[i,2] <- odgi[i,2] + odgi_draw[i,2] # we add up the time
  odgi[i,3] <- max(odgi[i,3], odgi_draw[i,3]) # we find the maximum RAM 
  odgi[i,4] <- "odgi"
}

#BandageNG_csv <- "/home/heumos/Downloads/hogwild_paper/BandageNG/BandageNG_time.csv"
BandageNG <- read.delim(BandageNG_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(BandageNG) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
BandageNG$tool <- "BandageNG"
BandageNG$time <- as.numeric(time_to_seconds(BandageNG$time))
summary(BandageNG)

#Bandage_csv <- "/home/heumos/Downloads/hogwild_paper/Bandage/Bandage_time.csv"
Bandage <- read.delim(Bandage_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(Bandage) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
Bandage$tool <- "Bandage"
Bandage$time <- as.numeric(time_to_seconds(Bandage$time))
summary(Bandage)

#gfaviz_csv <- "/home/heumos/Downloads/hogwild_paper/gfaviz/gfaviz_time.csv"
#gfaviz <- read.delim(gfaviz_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
#colnames(gfaviz) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
#gfaviz$tool <- "gfaviz"
#summary(gfaviz)

#layout <- rbind(odgi, BandageNG, Bandage, gfaviz)
layout <- rbind(odgi, BandageNG, Bandage)
layout$memory <- as.numeric(layout$memory)/1000000

dodge <- position_dodge(width = 0.0)

first_column <- c(1,2,4,8,16,32,64)
second_column <- c("*", "**", "**", "**", "**", "**", "**")
df <- data.frame(first_column, second_column)
colnames(df) <- c("haps", "label")

l_p_t <- ggplot(layout, aes(x=tool, y=time, fill=tool, color = tool, group=tool)) +
  #geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  geom_violin() +
  labs(x = "tool", y = "time in seconds") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
  #theme(legend.title = element_text(size=15)) +
  #theme(legend.key.size = unit(0.4, 'cm'))
l_p_t

get_legend <- function(a.gplot) {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(l_p_t)
l_p_t <- l_p_t + theme(legend.position = "none")
l_p_t


# TODO maybe take the mean for geom_point()
layout_m <- aggregate(cbind(memory,time) ~tool, data=layout, FUN=mean)
l_p_m <- ggplot(layout, aes(x=tool, y=memory, fill=tool, color = tool, group=tool)) +
  #geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  geom_violin() +
  labs(x = "tool", y = "memory in gigabytes") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
l_p_m

legend <- get_legend(l_p_m)
l_p_m <- l_p_m + theme(legend.position = "none")
l_p_m

grid.arrange(arrangeGrob(l_p_t, l_p_m, nrow = 1), nrow = 2, heights = c(1,0.05))

layout_save <- arrangeGrob(arrangeGrob(l_p_t, l_p_m, nrow = 1), nrow = 2, heights = c(1,0.05))
#layout_pdf <- "/home/heumos/Downloads/hogwild_paper/layout_eval.pdf"
ggsave(file=layout_pdf, layout_save, width = 7, height = 3.5)
file.remove("Rplots.pdf")

#### ONLY RELEVANT IF WE HAVE TO GO BY HAPLOTYPES ####
#layout_latex <- setNames(data.frame(matrix(ncol = 8, nrow = 0)), 
#                      c("time_Bandage", "time_BandageNG", "time_gfaviz", "time_odgi", 
#                        "memory_Bandage", "memory_BandageNG", "memory_gfaviz", "memory_odgi"))
#i <- 1
#j <- i + 1

#while(i < dim(layout_m)[1]) {
#  row_row_row_your_boat <- c(layout_m[i,1], layout_m[i,4], layout_m[j,4], layout_m[i,3], layout_m[j,3])
#  viz_latex <- rbind(viz_latex, row_row_row_your_boat)
#  i <- i + 2
#  j <- i + 1
#}
#colnames(viz_latex) <-  c("haps", "time_odgi_viz", "time_vg_viz", "memory_odgi_viz", "memory_vg_viz")
layout_m$memory <- round(layout_m$memory, 2)
layout_m$time <- round(layout_m$time, 2)
#layout_csv <- "/home/heumos/Downloads/hogwild_paper/layout_supp.csv"
write.table(layout_m, file = layout_csv, sep = ",", row.names = F, quote = F)
