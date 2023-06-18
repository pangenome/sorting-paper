pggb -i primates14.chr8.fa.gz -n 14 -o primates14.chr8 -D /scratch

odgi inject -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.og -b beta_defensin.bed -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -t 8 -P
odgi paths -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -L | cut -f 1,2 -d '#' | sort | uniq > prefixes.txt
odgi viz -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -M prefixes.txt -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.merged.png
