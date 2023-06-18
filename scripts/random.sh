pggb -i primates14.chr8.fa.gz -n 14 -o primates14.chr8 -D /scratch

odgi inject -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.og -b beta_defensin.bed -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -P
odgi paths -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -L | cut -f 1,2 -d '#' | sort | uniq > prefixes.txt
odgi viz -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.og -M prefixes.txt -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.inject.merged.z.png -z

odgi sort -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.og -t 48 -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.Ygs.sort_by_ref.og -p Ygs -P --temp-dir /scratch -H <(echo grch38#chr8)
odgi inject -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.Ygs.sort_by_ref.og -b beta_defensin.bed -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.Ygs.sort_by_ref.inject.og -P
odgi viz -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.Ygs.sort_by_ref.inject.og -M prefixes.txt -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.Ygs.sort_by_ref.inject.merged.z.png -z

odgi sort -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.og -t 48 -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.gY.sort_by_ref.og -p gY -P --temp-dir /scratch -H <(echo grch38#chr8)
odgi inject -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.gY.sort_by_ref.og -b beta_defensin.bed -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.gY.sort_by_ref.inject.og -P
odgi viz -i primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.gY.sort_by_ref.inject.og -M prefixes.txt -o primates14.chr8/primates14.chr8.fa.gz.667b9b6.417fcdf.8abe853.smooth.final.gY.sort_by_ref.inject.merged.z.png -z
