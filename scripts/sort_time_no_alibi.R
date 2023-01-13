#!/usr/bin/env Rscript

library(tidyverse)
library(ggbeeswarm)
library(gridExtra)

args <- commandArgs(trailingOnly = T)

odgi_Y_csv <- args[1]
odgi_s_csv <- args[2]
odgi_Ygs_csv <- args[3]
sort_pdf <- args[4]
sort_csv <- args[5]

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

#odgi_Y_csv <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_Y/odgi_Y_time.csv"
odgi_Y <- read.delim(odgi_Y_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(odgi_Y) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
odgi_Y$tool <- "odgi Y"
odgi_Y$time <- as.numeric(time_to_seconds(odgi_Y$time))
summary(odgi_Y)

#odgi_s_csv <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_s/odgi_s_time.csv"
odgi_s <- read.delim(odgi_s_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(odgi_s) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
odgi_s$tool <- "odgi s"
odgi_s$time <- as.numeric(time_to_seconds(odgi_s$time))
summary(odgi_s)

#odgi_Ygs_csv <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_Ygs/odgi_Ygs_time.csv"
odgi_Ygs <- read.delim(odgi_Ygs_csv, sep = ",", as.is = T, header = F, stringsAsFactors = F, strip.white = T)
colnames(odgi_Ygs) <- c("run", "time", "memory")
# time is in seconds
# memory is in kilobytes
odgi_Ygs$tool <- "odgi Ygs"
odgi_Ygs$time <- as.numeric(time_to_seconds(odgi_Ygs$time))
summary(odgi_Ygs)  

sort <- rbind(odgi_Y, odgi_s, odgi_Ygs)
sort$memory <- as.numeric(sort$memory)/1000000

s_p_t <- ggplot(sort, aes(x=tool, y=time, fill=tool, color = tool, group=tool)) +
  #geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  geom_violin() +
  labs(x = "tool", y = "time in seconds") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
  #theme(legend.title = element_text(size=15)) +
  #theme(legend.key.size = unit(0.4, 'cm'))
s_p_t

get_legend <- function(a.gplot) {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(s_p_t)
s_p_t <- s_p_t + theme(legend.position = "none")
s_p_t


# TODO maybe take the mean for geom_point()
sort_m <- aggregate(cbind(memory,time) ~tool, data=sort, FUN=mean)
s_p_m <- ggplot(sort, aes(x=tool, y=memory, fill=tool, color = tool, group=tool)) +
  #geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  geom_violin() +
  labs(x = "tool", y = "memory in gigabytes") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
s_p_m

legend <- get_legend(s_p_m)
s_p_m <- s_p_m + theme(legend.position = "none")
s_p_m

grid.arrange(arrangeGrob(s_p_t, s_p_m, nrow = 1), nrow = 2, heights = c(1,0.05))

sort_save <- arrangeGrob(arrangeGrob(s_p_t, s_p_m, nrow = 1), nrow = 2, heights = c(1,0.05))
#sort_pdf <- "/home/heumos/Downloads/hogwild_paper/1D/layout_eval.pdf"
ggsave(file=sort_pdf, sort_save, width = 7, height = 3.5)
file.remove("Rplots.pdf")

sort_m$memory <- round(sort_m$memory, 2)
sort_m$time <- round(sort_m$time, 2)
#sort_csv <- "/home/heumos/Downloads/hogwild_paper/1D/layout_supp.csv"
write.table(sort_m, file = sort_csv, sep = ",", row.names = F, quote = F)
