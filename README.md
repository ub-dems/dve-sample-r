# dvesimpler


## Setup

### Libraries


```bash


sudo apt install r-cran-stringr

# R -e 'install.packages("LMest")'



```


```R

# base
library(stringr)


sessionInfo()


```

### Project


```bash

mkdir -p ~/work/vs
cd       ~/work/vs

git clone git@gitlab.com:ub-dems-public/ds-labs/dve-sample-r.git

```

## Build


####  Rebuld

```bash
R CMD INSTALL --preclean --no-multiarch --with-keep.source dve-sample-r
```

####  ReLoad

```R
devtools::load_all(".")
```


####  Document

```R
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
```

####  Verify

```R
# test
devtools::test()

# check
devtools::check()
```



####  Package

```R

# source package
devtools::build()

#binary package
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build(binary = TRUE, args = c('--preclean'))

```




## Usage

#### exec scripts

```bash
# go to project base dir
cd ~/work/vs/dve-sample-r

# run batch scripts
Rscript exec/dummy_runner.R

```


---

## NOTE

*WARNING* _do not commit (big) data files in git repository_