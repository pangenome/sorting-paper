# PG-SGD paper

## resources

TODO.

## building the manuscript

```bash
# Dependencies
sudo apt-get -y install texlive texlive-latex-recommended \
        texlive-pictures texlive-latex-extra texlive-fonts-extra \
        texlive-science

git clone https://github.com/pangenome/sorting-paper
cd hogwild-layout/manuscript && make -k
```

## Oxford Bioinformatics Application Notes paper author instructions
https://academic.oup.com/bioinformatics/pages/instructions_for_authors

Application Notes: up to 4 pages; this is approx. 2,600 words or 2,000 words plus one figure.

```shell
# Count the number of words
pdftotext main.pdf - | egrep -e '\w\w\w+' | iconv -f ISO-8859-15 -t UTF-8 | wc -w 
```