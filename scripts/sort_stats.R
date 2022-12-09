#!/usr/bin/env Rscript

library(tidyverse)
library(ggbeeswarm)
library(gridExtra)
library(yaml)

args <- commandArgs(trailingOnly = T)

odgi_Y_yml <- args[1]
odgi_s_yml <- args[2]
odgi_Ygs_yml <- args[3]
alibi_yml <- args[4]
stats_pdf <- args[5]
stats_csv <- args[6]

#odgi_Y_yml <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_Y/DRB1-3123.fa.gz.seqwish.gfa.Y.og.stats.yml"
odgi_Y <- read_yaml(odgi_Y_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
odgi_Y_stats <- c(odgi_Y$mean_links_length[[1]]$length$in_node_space,
                  odgi_Y$mean_links_length[[1]]$length$in_nucleotide_space,
                  odgi_Y$sum_of_path_node_distances[[1]]$distance$in_node_space,
                  odgi_Y$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                  "odgi Y")
odgi_Y_stats <- t(data.frame(odgi_Y_stats))
colnames(odgi_Y_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", "sopnd_in_nuc_space", "tool")

#odgi_s_yml <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_s/DRB1-3123.fa.gz.seqwish.gfa.s.og.stats.yml"
odgi_s <- read_yaml(odgi_s_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
odgi_s_stats <- c(odgi_s$mean_links_length[[1]]$length$in_node_space,
                  odgi_s$mean_links_length[[1]]$length$in_nucleotide_space,
                  odgi_s$sum_of_path_node_distances[[1]]$distance$in_node_space,
                  odgi_s$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                  "odgi s")
odgi_s_stats <- t(data.frame(odgi_s_stats))
colnames(odgi_s_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", "sopnd_in_nuc_space", "tool")

#odgi_Ygs_yml <- "/home/heumos/Downloads/hogwild_paper/1D/odgi_Ygs/DRB1-3123.fa.gz.seqwish.gfa.Ygs.og.stats.yml"
odgi_Ygs <- read_yaml(odgi_Ygs_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
odgi_Ygs_stats <- c(odgi_Ygs$mean_links_length[[1]]$length$in_node_space,
                    odgi_Ygs$mean_links_length[[1]]$length$in_nucleotide_space,
                    odgi_Ygs$sum_of_path_node_distances[[1]]$distance$in_node_space,
                    odgi_Ygs$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                    "odgi Ygs")
odgi_Ygs_stats <- t(data.frame(odgi_Ygs_stats))
colnames(odgi_Ygs_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", "sopnd_in_nuc_space", "tool")

#alibi_yml <- "/home/heumos/Downloads/hogwild_paper/1D/alibi/DRB1-3123.fa.gz.seqwish.gfa.alibi.og.stats.yml"
alibi <- read_yaml(alibi_yml, fileEncoding = "UTF-8", text, readLines.warn=TRUE)
alibi_stats <- c(alibi$mean_links_length[[1]]$length$in_node_space,
                 alibi$mean_links_length[[1]]$length$in_nucleotide_space,
                 alibi$sum_of_path_node_distances[[1]]$distance$in_node_space,
                 alibi$sum_of_path_node_distances[[1]]$distance$in_nucleotide_space,
                 "alibi")
alibi_stats <- t(data.frame(alibi_stats))
colnames(alibi_stats) <- c("mll_in_node_space", "mll_in_nuc_space", "sopnd_in_node_space", "sopnd_in_nuc_space", "tool")

#layout <- rbind(odgi, BandageNG, Bandage, gfaviz)
stats <- as.data.frame(rbind(odgi_Y_stats, odgi_s_stats, odgi_Ygs_stats, alibi_stats))
stats$mll_in_node_space <- as.numeric(stats$mll_in_node_space)
stats$mll_in_nuc_space <- as.numeric(stats$mll_in_nuc_space)
stats$sopnd_in_node_space <- as.numeric(stats$sopnd_in_node_space)
stats$sopnd_in_nuc_space <- as.numeric(stats$sopnd_in_nuc_space)

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

#### TODO ####
#### CONTINUE HERE ####
grid.arrange(arrangeGrob(s_p_mll_node, s_p_mll_nuc, s_p_sopnd_node, s_p_sopnd_nuc, nrow = 2), nrow = 2, heights = c(1,0.05))

stats_save <- arrangeGrob(arrangeGrob(s_p_mll_node, s_p_mll_nuc, s_p_sopnd_node, s_p_sopnd_nuc, nrow = 2), nrow = 2, heights = c(1,0.05))
#stats_pdf <- "/home/heumos/Downloads/hogwild_paper/1D/stats.pdf"
ggsave(file=stats_pdf, stats_save, width = 7, height = 3.5)
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
#sort_m$memory <- round(sort_m$memory, 2)
#sort_m$time <- round(sort_m$time, 2)
#stats_csv <- "/home/heumos/Downloads/hogwild_paper/1D/stats_supp.csv"
write.table(stats, file = stats_csv, sep = ",", row.names = F, quote = F)
