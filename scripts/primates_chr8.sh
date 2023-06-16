screen -R p14_chr8_p95_s5k_k79
mkdir p14_chr8_p95_s5k_k79
cd p14_chr8_p95_s5k_k79
nextflow run nf-core/pangenome -r dev -profile cfc --input ~/data/primates/primates14.chr8.fa.gz -c /home-link/afaaj01/hprc_chr16_brave_sing.config --n_haplotypes 14 --wfmash_map_pct_id 95 --wfmash_segment_length 5000 --wfmash_chunks 20 -w work_primates14_chr8_p95_s5k_k79 --outdir results_primates14_chr8_p95_s5k_k79 --seqwish_min_match_length 79

screen -R p14_chr8_p90_s5k_k79
mkdir p14_chr8_p90_s5k_k79
cd p14_chr8_p90_s5k_k79
nextflow run nf-core/pangenome -r dev -profile cfc --input ~/data/primates/primates14.chr8.fa.gz -c /home-link/afaaj01/hprc_chr16_brave_sing.config --n_haplotypes 14 --wfmash_map_pct_id 90 --wfmash_segment_length 5000 --wfmash_chunks 20 -w work_primates14_chr8_p90_s5k_k79 --outdir results_primates14_chr8_p90_s5k_k79 --seqwish_min_match_length 79

screen -R p14_chr8_p95_s5k_k311
mkdir p14_chr8_p95_s5k_k311
cd p14_chr8_p95_s5k_k311
nextflow run nf-core/pangenome -r dev -profile cfc --input ~/data/primates/primates14.chr8.fa.gz -c /home-link/afaaj01/hprc_chr16_brave_sing.config --n_haplotypes 14 --wfmash_map_pct_id 95 --wfmash_segment_length 5000 --wfmash_chunks 20 -w work_primates14_chr8_p95_s5k_k311 --outdir results_primates14_chr8_p95_s5k_k311 --seqwish_min_match_length 311

screen -R p14_chr8_p90_s5k_k311
mkdir p14_chr8_p90_s5k_k311
cd p14_chr8_p90_s5k_k311
nextflow run nf-core/pangenome -r dev -profile cfc --input ~/data/primates/primates14.chr8.fa.gz -c /home-link/afaaj01/hprc_chr16_brave_sing.config --n_haplotypes 14 --wfmash_map_pct_id 90 --wfmash_segment_length 5000 --wfmash_chunks 20 -w work_primates14_chr8_p90_s5k_k311 --outdir results_primates14_chr8_p90_s5k_k311 --seqwish_min_match_length 311
