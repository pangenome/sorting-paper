# PG-SGD paper

## resources

https://github.com/human-pangenomics/hpp_pangenome_resources

## building the manuscript

```bash
# Dependencies
sudo apt-get -y install texlive texlive-latex-recommended \
        texlive-pictures texlive-latex-extra texlive-fonts-extra \
        texlive-science

git clone https://github.com/pangenome/sorting-paper
cd sorting-paper/manuscript && make -k
```

## Oxford Bioinformatics Application Notes paper author instructions
https://academic.oup.com/bioinformatics/pages/instructions_for_authors

Application Notes: up to 4 pages; this is approx. 2,600 words or 2,000 words plus one figure.

```shell
# Count the number of words
pdftotext main.pdf - | egrep -e '\w\w\w+' | iconv -f ISO-8859-15 -t UTF-8 | wc -w 
```
## Link to 2D sketch
https://docs.google.com/presentation/d/1CRigpZKdGM9MGY8RLh-WhRo69AeMMAhvapOYvXKrEsM/edit#slide=id.g24520d7241f_0_3

## How to generate Supplementary
pdftk manuscript/main.pdf cat 7-end output manuscript/supplementary.pdf

## Note about the scripts folder
Since the maturation of the manuscript, only the scripts in folder `scripts/cfc` are relevant for the manuscript.
