#!/usr/bin/env Rscript

library(tidyverse)
library(ggbeeswarm)
library(gridExtra)
library(yaml)

args <- commandArgs(trailingOnly = T)

odgi_Y_yml <- args[1]
odgi_s_yml <- args[2]
odgi_Ygs_yml <- args[3]
stats_pdf <- args[4]
stats_csv <- args[5]

#odgi_Y_yml <- "/home/heumos/Downloads/hogwild_paper/1D/DRB1-3123/odgi_Y/DRB1-3123.fa.gz.seqwish.gfa.Y.og.stats.yml"
odgi_Y <- read_yaml(odgi_Y_yml, readLines.warn=TRUE)
odgi_Y_stats <- c(odgi_Y$mean_links_length[[1]]$length$in_node_space,
                  odgi_Y$mean_links_length[[1]]$length$in_nucleotide_space,
                  odgi_Y$sum_of_path_node_distances[[1]]$distance$in_node_space,
                  odgi_Y$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                  paste(odgi_Y$weighted_feedback_arc, "0", sep = "."),
                  paste(odgi_Y$weighted_reversing_join, "0", sep = "."),
                  "odgi_Y")
odgi_Y_stats <- t(data.frame(odgi_Y_stats))
colnames(odgi_Y_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", 
                            "sopnd_in_nuc_space", "weighted_feedback_arc", "weighted_reversing_join", "tool")

#odgi_s_yml <- "/home/heumos/Downloads/hogwild_paper/1D/DRB1-3123/odgi_s/DRB1-3123.fa.gz.seqwish.gfa.s.og.stats.yml"
odgi_s <- read_yaml(odgi_s_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
odgi_s_stats <- c(odgi_s$mean_links_length[[1]]$length$in_node_space,
                  odgi_s$mean_links_length[[1]]$length$in_nucleotide_space,
                  odgi_s$sum_of_path_node_distances[[1]]$distance$in_node_space,
                  odgi_s$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                  paste(odgi_s$weighted_feedback_arc, "0", sep = "."),
                  paste(odgi_s$weighted_reversing_join, "0", sep = "."),
                  "odgi_s")
odgi_s_stats <- t(data.frame(odgi_s_stats))
colnames(odgi_s_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", 
                            "sopnd_in_nuc_space", "weighted_feedback_arc", "weighted_reversing_join", "tool")

#odgi_Ygs_yml <- "/home/heumos/Downloads/hogwild_paper/1D/DRB1-3123/odgi_Ygs/DRB1-3123.fa.gz.seqwish.gfa.Ygs.og.stats.yml"
odgi_Ygs <- read_yaml(odgi_Ygs_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
odgi_Ygs_stats <- c(odgi_Ygs$mean_links_length[[1]]$length$in_node_space,
                    odgi_Ygs$mean_links_length[[1]]$length$in_nucleotide_space,
                    odgi_Ygs$sum_of_path_node_distances[[1]]$distance$in_node_space,
                    odgi_Ygs$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                    paste(odgi_Ygs$weighted_feedback_arc, "0", sep = "."),
                    paste(odgi_Ygs$weighted_reversing_join, "0", sep = "."),
                    "odgi_Ygs")
odgi_Ygs_stats <- t(data.frame(odgi_Ygs_stats))
colnames(odgi_Ygs_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", 
                              "sopnd_in_nuc_space", "weighted_feedback_arc", "weighted_reversing_join", "tool")

#layout <- rbind(odgi, BandageNG, Bandage, gfaviz)
stats <- as.data.frame(rbind(odgi_Y_stats, odgi_s_stats, odgi_Ygs_stats))
stats$mll_in_node_space <- as.numeric(stats$mll_in_node_space)
stats$mll_in_nuc_space <- as.numeric(stats$mll_in_nuc_space)
stats$sopnd_in_node_space <- as.numeric(stats$sopnd_in_node_space)
stats$sopnd_in_nuc_space <- as.numeric(stats$sopnd_in_nuc_space)
stats <- transform(stats, weighted_feedback_arc = as.numeric(weighted_feedback_arc), 
          weighted_reversing_join = as.numeric(weighted_reversing_join))
# is.numeric(stats$weighted_feedback_arc) https://stackoverflow.com/questions/2288485/how-to-convert-a-data-frame-column-to-numeric-type

s_p_mll_node <- ggplot(stats, aes(x=tool, y=mll_in_node_space, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "mll - node") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
s_p_mll_node

get_legend <- function(a.gplot) {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(s_p_mll_node)
s_p_mll_node <- s_p_mll_node + theme(legend.position = "none")
s_p_mll_node

s_p_mll_nuc <- ggplot(stats, aes(x=tool, y=mll_in_nuc_space, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "mll - nuc") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
s_p_mll_nuc

legend <- get_legend(s_p_mll_nuc)
s_p_mll_nuc <- s_p_mll_nuc + theme(legend.position = "none")
s_p_mll_nuc

s_p_sopnd_nuc <- ggplot(stats, aes(x=tool, y=sopnd_in_nuc_space, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "sopnd - nuc") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
s_p_sopnd_nuc

legend <- get_legend(s_p_sopnd_nuc)
s_p_sopnd_nuc <- s_p_sopnd_nuc + theme(legend.position = "none")
s_p_sopnd_nuc

s_p_sopnd_node <- ggplot(stats, aes(x=tool, y=sopnd_in_node_space, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "sopnd - node") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
s_p_sopnd_node

legend <- get_legend(s_p_sopnd_node)
s_p_sopnd_node <- s_p_sopnd_node + theme(legend.position = "none")
s_p_sopnd_node

w_f_a <- ggplot(stats, aes(x=tool, y=weighted_feedback_arc, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "weighted feedback arc") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
w_f_a

legend <- get_legend(w_f_a)
w_f_a <- w_f_a + theme(legend.position = "none")
w_f_a

w_r_j <- ggplot(stats, aes(x=tool, y=weighted_reversing_join, fill=tool, color = tool, group=tool)) +
  geom_point() + geom_line() +
  #geom_beeswarm(size=0.5) +
  #geom_violin() +
  labs(x = "tool", y = "weighted reversing join") +
  expand_limits(x = 0, y = 0) + theme(legend.direction = "horizontal") + 
  labs(color = "tool   ") + 
  labs(fill = "tool   ") 
#theme(legend.title = element_text(size=15)) +
#theme(legend.key.size = unit(0.4, 'cm'))
w_r_j

legend <- get_legend(w_r_j)
w_r_j <- w_r_j + theme(legend.position = "none")
w_r_j

grid.arrange(arrangeGrob(s_p_mll_node, s_p_mll_nuc, s_p_sopnd_node, s_p_sopnd_nuc, w_f_a, w_r_j, nrow = 3), nrow = 2, heights = c(1,0.05))

stats_save <- arrangeGrob(arrangeGrob(s_p_mll_node, s_p_mll_nuc, s_p_sopnd_node, s_p_sopnd_nuc, w_f_a, w_r_j, nrow = 3), nrow = 2, heights = c(1,0.05))
#stats_pdf <- "/home/heumos/Downloads/hogwild_paper/1D/stats.pdf"
ggsave(file=stats_pdf, stats_save, width = 6, height = 5.5)
file.remove("Rplots.pdf")

write.table(stats, file = stats_csv, sep = ",", row.names = F, quote = F)
