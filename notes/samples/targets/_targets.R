# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c(
    "readr",
    "ggplot2",
    "dplyr",
    "lubridate",
    "yaml",
    "logging",
    "modules"), # packages that your targets need to run
  format = "rds" # default storage format
  # format = "feather" # efficient storage of large data frames # nolint
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(
    name = dmy_hello_a,
    command = dmy_hello()
  ),
  tar_target(
    name = dmy_fd_net_PJME_hourly_z,
    command = dmy_p01_list_zip_share_data()
  ),
  tar_target(
    name = dmy_fd_net_PJME_hourly,
    command = dmy_p01_copy_zip_share_data(dmy_fd_net_PJME_hourly_z$fn)
  ),
  tar_target(
    name = dmy_df_PJME_hourly,
    command = dmy_p01_load_host_local_data(dmy_fd_net_PJME_hourly$fn),
    format = "feather"
  ),
  tar_target(
    name = dmy_fd_def_PJME_hourly_3y,
    command = dmy_p01_save_user_private_data(dmy_df_PJME_hourly, from_date = "2016-01-01", to_date = "2019-01-01")
  ),
  tar_target(
    name = dmy_df_PJME_hourly_3y,
    command = dmy_p01_load_user_private_data(dmy_fd_def_PJME_hourly_3y$fn),
    format = "feather"
  ),
  tar_target(
    name = dmy_fd_txt_PJME_hourly,
    command = dmy_p01_show_host_local_data(dmy_df_PJME_hourly)
  ),
  tar_target(
    name = dmy_fd_tmp_PJME_hourly,
    command = dmy_p01_plot_host_local_data(dmy_df_PJME_hourly)
  ),
  tar_target(
    name = dmy_fd_txt_PJME_hourly_3y,
    command = dmy_p01_show_user_private_data(dmy_df_PJME_hourly_3y)
  ),
  tar_target(
    name = dmy_fd_tmp_PJME_hourly_3y,
    command = dmy_p01_plot_user_private_data(dmy_df_PJME_hourly_3y)
  ),
  tar_target(
    name = dmy_hello_b,
    command = dmy_hello("Moon", "'Night")
  )
)
