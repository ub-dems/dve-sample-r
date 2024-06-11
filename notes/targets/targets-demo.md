CRAN "targets" demo
===================

References
----------

* [An overview of targets](https://cran.r-project.org/web/packages/targets/vignettes/overview.html)


Spec
----

* [_targets.R](../../_targets.R)
* [R/dummy_proc.R](../../R/dummy_proc.R)
* [R/dummy_path.R](../../R/dummy_path.R)


Scripts
-------

* [exec/dummy_reader.R](../../exec/dummy_reader.R)
* [exec/pipeline_runner.R](../../exec/pipeline_runner.R)
* [exec/runner.R](../../exec/runner.R)


Package
-------
* [starter.sh](../../starter.sh)
* [worker.sh](../../worker.sh)
* [build.sh](../../build.sh)


------------------------------------------------------------------------------------------

DEMO
----

```R

> targets::tar_glimpse()
 
> targets::tar_destroy()

Delete _targets? (Set the TAR_ASK environment variable to "false" to disable this menu, e.g. usethis::edit_r_environ().) 

1: yes
2: no

Selection: 1


> targets::tar_outdated()

 [1] "dmy_fd_txt_PJME_hourly"    "dmy_hello_a"               "dmy_df_PJME_hourly_3y"     "dmy_hello_b"              
 [5] "dmy_fd_net_PJME_hourly_z"  "dmy_fd_tmp_PJME_hourly"    "dmy_fd_net_PJME_hourly"    "dmy_fd_tmp_PJME_hourly_3y"
 [9] "dmy_fd_txt_PJME_hourly_3y" "dmy_fd_def_PJME_hourly_3y" "dmy_df_PJME_hourly"       


> targets::tar_make()

▶ start target dmy_hello_a
● built target dmy_hello_a [0.457 seconds]
▶ start target dmy_hello_b
● built target dmy_hello_b [0.001 seconds]
▶ start target dmy_fd_net_PJME_hourly_z
2023-08-01 15:28:03.676101 INFO::# list_zip: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.net/examples/kaggle-pjm/zip/PJME_hourly.csv.zip
● built target dmy_fd_net_PJME_hourly_z [0.09 seconds]
▶ start target dmy_fd_net_PJME_hourly
2023-08-01 15:28:03.715119 INFO::# read_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.net/examples/kaggle-pjm/zip/PJME_hourly.csv.zip
2023-08-01 15:28:04.094675 INFO::# write_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.loc/examples/kaggle-pjm/raw/PJME_hourly.csv
● built target dmy_fd_net_PJME_hourly [0.453 seconds]
▶ start target dmy_df_PJME_hourly
2023-08-01 15:28:04.148247 INFO::# read_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.loc/examples/kaggle-pjm/raw/PJME_hourly.csv
2023-08-01 15:28:04.3303 INFO::# report: /root/work/cs/multi-spatial-pred-stack/temp/PJME_hourly.txt
● built target dmy_df_PJME_hourly [0.033 seconds]
▶ start target dmy_fd_txt_PJME_hourly
● built target dmy_fd_txt_PJME_hourly [0.037 seconds]
▶ start target dmy_fd_def_PJME_hourly_3y
2023-08-01 15:28:04.3812 INFO::# write_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.def/examples/kaggle-pjm/raw/PJME_hourly-3y.csv
● built target dmy_fd_def_PJME_hourly_3y [0.094 seconds]
▶ start target dmy_fd_tmp_PJME_hourly
2023-08-01 15:28:04.477952 INFO::# plot: /root/work/cs/multi-spatial-pred-stack/temp/PJME_hourly.pdf
● built target dmy_fd_tmp_PJME_hourly [0.742 seconds]
2023-08-01 15:28:05.212944 INFO::# read_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.def/examples/kaggle-pjm/raw/PJME_hourly-3y.csv
▶ start target dmy_df_PJME_hourly_3y
● built target dmy_df_PJME_hourly_3y [0.01 seconds]
▶ start target dmy_fd_tmp_PJME_hourly_3y
2023-08-01 15:28:05.228927 INFO::# plot: /root/work/cs/multi-spatial-pred-stack/temp/PJME_hourly-3y.pdf
2023-08-01 15:28:05.361958 INFO::# report: /root/work/cs/multi-spatial-pred-stack/temp/PJME_hourly-3y.txt
● built target dmy_fd_tmp_PJME_hourly_3y [0.13 seconds]
▶ start target dmy_fd_txt_PJME_hourly_3y
● built target dmy_fd_txt_PJME_hourly_3y [0.004 seconds]
▶ end pipeline [2.361 seconds]
 
> targets::tar_make()

✔ skip target dmy_hello_a
✔ skip target dmy_hello_b
✔ skip target dmy_fd_net_PJME_hourly_z
✔ skip target dmy_fd_net_PJME_hourly
✔ skip target dmy_df_PJME_hourly
✔ skip target dmy_fd_txt_PJME_hourly
✔ skip target dmy_fd_def_PJME_hourly_3y
✔ skip target dmy_fd_tmp_PJME_hourly
✔ skip target dmy_df_PJME_hourly_3y
✔ skip target dmy_fd_tmp_PJME_hourly_3y
✔ skip target dmy_fd_txt_PJME_hourly_3y
✔ skip pipeline [0.214 seconds]
 
> targets::tar_outdated()

character(0)


> targets::tar_invalidate("dmy_fd_def_PJME_hourly_3y")

> targets::tar_outdated()

[1] "dmy_df_PJME_hourly_3y"     "dmy_fd_tmp_PJME_hourly_3y" "dmy_fd_txt_PJME_hourly_3y" "dmy_fd_def_PJME_hourly_3y"


> targets::tar_make()

✔ skip target dmy_hello_a
✔ skip target dmy_hello_b
✔ skip target dmy_fd_net_PJME_hourly_z
✔ skip target dmy_fd_net_PJME_hourly
✔ skip target dmy_df_PJME_hourly
✔ skip target dmy_fd_txt_PJME_hourly
▶ start target dmy_fd_def_PJME_hourly_3y
2023-08-01 15:29:05.674034 INFO::# write_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.def/examples/kaggle-pjm/raw/PJME_hourly-3y.csv
● built target dmy_fd_def_PJME_hourly_3y [0.149 seconds]
✔ skip target dmy_fd_tmp_PJME_hourly
▶ start target dmy_df_PJME_hourly_3y
2023-08-01 15:29:05.815107 INFO::# read_csv: /root/work/cs/multi-spatial-pred-stack/inst/extdata/ext/msp-ds.def/examples/kaggle-pjm/raw/PJME_hourly-3y.csv
● built target dmy_df_PJME_hourly_3y [0.043 seconds]
✔ skip target dmy_fd_tmp_PJME_hourly_3y
✔ skip target dmy_fd_txt_PJME_hourly_3y
▶ end pipeline [1.01 seconds]
 
> targets::tar_make()

✔ skip target dmy_hello_a
✔ skip target dmy_hello_b
✔ skip target dmy_fd_net_PJME_hourly_z
✔ skip target dmy_fd_net_PJME_hourly
✔ skip target dmy_df_PJME_hourly
✔ skip target dmy_fd_txt_PJME_hourly
✔ skip target dmy_fd_def_PJME_hourly_3y
✔ skip target dmy_fd_tmp_PJME_hourly
✔ skip target dmy_df_PJME_hourly_3y
✔ skip target dmy_fd_tmp_PJME_hourly_3y
✔ skip target dmy_fd_txt_PJME_hourly_3y
✔ skip pipeline [0.154 seconds]


```
