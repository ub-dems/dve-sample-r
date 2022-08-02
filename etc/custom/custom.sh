#!/bin/bash
# Script Head
# #+NAME: script-heading

# [[file:../../notes/custom/README.org::script-heading][script-heading]]
##
# ./etc/custom/custom.sh: initial project template customization
# 
# @see: ./notes/custom/README.org

# run from project root:
#
if [ ! -d ./etc/custom ]; then
  echo '

    custom.sh: initial project template customization


    Usage:
            ./build.sh custom

    from project root

    Config:

     before customization, project informantion must be set in config:

      nano ./etc/custom/custom-target.conf

  '
  exit 1
fi

mkdir -p ./logs/custom
LOGFILE=./logs/custom/custom-$(date -Isec).log
exec &> >(tee $LOGFILE)
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3
#exec 1>$LOGFILE 2>&1

echo ">>> project customization, ..."
# script-heading ends here

# Info Session
# #+NAME: user-info

# [[file:../../notes/custom/README.org::user-info][user-info]]
whoami
# user-info ends here



# #+NAME: host-info

# [[file:../../notes/custom/README.org::host-info][host-info]]
hostnamectl | \
    perl -p -e 's/([^ :])\s+(\S)/\1_\2/g' | sed -e 's/:/\t/'
# host-info ends here




# #+NAME: net-info

# [[file:../../notes/custom/README.org::net-info][net-info]]
ip -br -4 a | grep -v lo
# net-info ends here




# #+NAME: project-info

# [[file:../../notes/custom/README.org::project-info][project-info]]
pwd
# project-info ends here



# #+NAME: repo-info

# [[file:../../notes/custom/README.org::repo-info][repo-info]]
git remote -v
# repo-info ends here



# #+NAME: repo-status

# [[file:../../notes/custom/README.org::repo-status][repo-status]]
git -c color.ui=false status | \
    sed -e 's/^/> /'
# repo-status ends here

# Source Config

# #+NAME: conf-custom

# [[file:../../notes/custom/README.org::conf-custom][conf-custom]]
[ -f ./etc/custom/custom.conf ] || sed 's/^ *//' >> ./etc/custom/custom.conf <<-EOF
# project customization config
set -a
#  
CUST_X_CUSTOMIZED=0
#  
. ./etc/custom/custom-source.conf  
. ./etc/custom/custom-target.conf  
#  
set +a
EOF
# conf-custom ends here



# #+RESULTS: conf-custom

# #+NAME: custom-source.conf

# [[file:../../notes/custom/README.org::custom-source.conf][custom-source.conf]]
[ -f ./etc/custom/custom-source.conf ] || sed 's/^ *//' >> ./etc/custom/custom-source.conf <<-EOF
##
# customization: project source consts
#
# ---(project)---
CUST_S_PROJECT_NAME='dve-sample-r'
# ---(package)---
CUST_S_PACKAGE_NAME='dvesimpler'
# ---(source repository)---
CUST_S_REPO_PATH='ub-dems-public/ds-labs'
CUST_S_REPO_HOST='https://gitlab.com/'
# ---(image registry)---
CUST_S_REGS_PATH='ubdems'
CUST_S_REGS_HOST='docker.io'
# ---(environment versions)---
CUST_S_IMAGE_ANCHOR='rocker/tidyverse:latest'
CUST_S_VERS_BASE='(>= 3.6.0)'
CUST_S_VERS_ROXY='7.2.0'
# ---(data import links)---
CUST_S_DATA_LINK='dve-ds'
# ---(renv support options)---
CUST_S_RENV_OPTS='enable,auto'
# ---(project description)---
CUST_S_INFO_AUTH_NAME='datalab'
CUST_S_INFO_AUTH_SURNAME='DEMS'
CUST_S_INFO_MAIL='dsuser.dems@gmail.com'
CUST_S_INFO_AUTHORS="${CUST_S_INFO_AUTH_SURNAME}/${CUST_S_INFO_AUTH_NAME} <${CUST_S_INFO_MAIL}>"
CUST_S_INFO_DESC='TODO:description'
CUST_S_INFO_TITLE='TODO:title'
CUST_S_INFO_FROM='2022-08-02'
CUST_S_INFO_OWNER='ab21010'
CUST_S_INFO_CDC='ds-101'
CUST_S_INFO_TAGS='none'
EOF
# custom-source.conf ends here

# Target Config

# #+NAME: custom-target.conf

# [[file:../../notes/custom/README.org::custom-target.conf][custom-target.conf]]
[ -f ./etc/custom/custom-target.conf ] || sed 's/^ *//' >> ./etc/custom/custom-target.conf <<-EOF
##
# customization: project target consts
#
# ---(project)---
CUST_T_PROJECT_NAME='us-proto-r'
# ---(package)---
CUST_T_PACKAGE_NAME='USprotoR'
# ---(source repository)---
CUST_T_REPO_PATH='ub-dems/cs-labs/user-dsuser'
CUST_T_REPO_HOST='https://gitlab.com/'
# ---(image registry)---
CUST_T_REGS_PATH='ubdems'
CUST_T_REGS_HOST='docker.io'
# ---(environment versions)---
CUST_T_IMAGE_ANCHOR='rocker/tidyverse:latest'
CUST_T_VERS_BASE='(>= 3.6.0)'
CUST_T_VERS_ROXY='7.2.0'
# ---(data import links)---
CUST_T_DATA_LINK='dve-ds'
# ---(renv support options)---
CUST_T_RENV_OPTS='enable,auto'
# ---(project description)---
CUST_T_INFO_AUTH_NAME='datalab'
CUST_T_INFO_AUTH_SURNAME='DEMS'
CUST_T_INFO_MAIL='dsuser.dems@gmail.com'
CUST_T_INFO_AUTHORS="${CUST_T_INFO_AUTH_SURNAME}/${CUST_T_INFO_AUTH_NAME} <${CUST_T_INFO_MAIL}>"
CUST_T_INFO_DESC='TODO:description'
CUST_T_INFO_TITLE='TODO:title'
CUST_T_INFO_FROM='2022-08-02'
CUST_T_INFO_OWNER='ab21010'
CUST_T_INFO_CDC='es-101'
CUST_T_INFO_TAGS='none'
EOF
# custom-target.conf ends here



# #+RESULTS: custom-target.conf

# #+NAME: conf-show

# [[file:../../notes/custom/README.org::conf-show][conf-show]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort
# conf-show ends here



# #+RESULTS: conf-show
# | CUST_S_PACKAGE_NAME | dvesimpler                  |
# | CUST_S_PROJECT_NAME | dve-sample-r                |
# | CUST_S_REPO_HOST    | https://gitlab.com/         |
# | CUST_S_REPO_PATH    | ub-dems-public/ds-labs      |
# | CUST_T_PACKAGE_NAME | USprotoR                    |
# | CUST_T_PROJECT_NAME | us-proto-r                  |
# | CUST_T_REPO_HOST    | https://gitlab.com/         |
# | CUST_T_REPO_PATH    | ub-dems/cs-labs/user-dsuser |
# | CUST_X_CUSTOMIZED   | 0                           |

# #+NAME: conf-check

# [[file:../../notes/custom/README.org::conf-check][conf-check]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
if [ ! "${CUST_X_CUSTOMIZED}" = '0' ] ; then
  echo '

    WARNING: project already customized, exiting ...

    To re-enable customization, set

    CUST_X_CUSTOMIZED=0

    in ./etc/custom/custom.conf,

    update new target customization

    in ./etc/custom/custom-target.conf,

    and re-execute customization with:

    ./build.sh custom

  '
  exit 1
fi

[ -z "$CUST_S_PACKAGE_NAME" ] && { echo "config error: CUST_S_PACKAGE_NAME"; exit 1; }
[ -z "$CUST_S_PROJECT_NAME" ] && { echo "config error: CUST_S_PROJECT_NAME"; exit 1; }
[ -z "$CUST_S_REPO_HOST" ]    && { echo "config error: CUST_S_REPO_HOST"; exit 1; }
[ -z "$CUST_S_REPO_PATH" ]    && { echo "config error: CUST_S_REPO_PATH"; exit 1; }
[ -z "$CUST_T_PACKAGE_NAME" ] && { echo "config error: CUST_T_PACKAGE_NAME"; exit 1; }
[ -z "$CUST_T_PROJECT_NAME" ] && { echo "config error: CUST_T_PROJECT_NAME"; exit 1; }
[ -z "$CUST_T_REPO_HOST" ]    && { echo "config error: CUST_T_REPO_HOST"; exit 1; }
[ -z "$CUST_T_REPO_PATH" ]    && { echo "config error: CUST_T_REPO_PATH"; exit 1; }
# conf-check ends here

# File Rename

# #+NAME: cust-rename-pre

# [[file:../../notes/custom/README.org::cust-rename-pre][cust-rename-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find . -name "$CUST_S_PACKAGE_NAME*" -o -name "$CUST_S_PROJECT_NAME*"
# cust-rename-pre ends here



# #+NAME: cust-rename

# [[file:../../notes/custom/README.org::cust-rename][cust-rename]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

mv -v ./${CUST_S_PACKAGE_NAME}.Rproj ./${CUST_T_PACKAGE_NAME}.Rproj
mv -v ./man/${CUST_S_PACKAGE_NAME}-package.Rd ./man/${CUST_T_PACKAGE_NAME}-package.Rd
mv -v ./R/${CUST_S_PACKAGE_NAME}.r ./R/${CUST_T_PACKAGE_NAME}.r
# cust-rename ends here



# #+NAME: cust-rename-post

# [[file:../../notes/custom/README.org::cust-rename-post][cust-rename-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find . -name "$CUST_T_PACKAGE_NAME*" -o -name "$CUST_T_PROJECT_NAME*"
# cust-rename-post ends here

# Environment Versions

# #+NAME: cust-vers-pre

# [[file:../../notes/custom/README.org::cust-vers-pre][cust-vers-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -F -e "$CUST_S_VERS_BASE" -e "$CUST_S_VERS_ROXY" ./DESCRIPTION
grep -F -e "$CUST_S_IMAGE_ANCHOR" ./docker/r-images/dockerfiles/anchor.Dockerfile
# cust-vers-pre ends here



# #+NAME: cust-vers

# [[file:../../notes/custom/README.org::cust-vers][cust-vers]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

perl -pi -e  "s/(\s+R\s+)\Q$CUST_S_VERS_BASE\E/\1\Q$CUST_T_VERS_BASE\E/" ./DESCRIPTION
perl -pi -e  "s/(RoxygenNote: )\Q$CUST_S_VERS_ROXY\E/\1\Q$CUST_T_VERS_ROXY\E/" ./DESCRIPTION

perl -pi -e  "s/\Q$CUST_S_IMAGE_ANCHOR\E/\Q$CUST_T_IMAGE_ANCHOR\E/" ./docker/r-images/dockerfiles/anchor.Dockerfile
# cust-vers ends here



# #+NAME: cust-vers-post

# [[file:../../notes/custom/README.org::cust-vers-post][cust-vers-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -F -e "$CUST_T_VERS_BASE" -e "$CUST_T_VERS_ROXY" ./DESCRIPTION
grep -F -e "$CUST_T_IMAGE_ANCHOR" ./docker/r-images/dockerfiles/anchor.Dockerfile
# cust-vers-post ends here

# Package Name

# #+NAME: cust-package-pre

# [[file:../../notes/custom/README.org::cust-package-pre][cust-package-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PACKAGE_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-package-pre ends here



# #+NAME: cust-package

# [[file:../../notes/custom/README.org::cust-package][cust-package]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PACKAGE_NAME" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_PACKAGE_NAME}{$CUST_T_PACKAGE_NAME}g"
# cust-package ends here




# #+NAME: cust-package-post

# [[file:../../notes/custom/README.org::cust-package-post][cust-package-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_PACKAGE_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-package-post ends here

# Repo Address

# #+NAME: cust-repo-pre

# [[file:../../notes/custom/README.org::cust-repo-pre][cust-repo-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_REPO_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-repo-pre ends here



# #+NAME: cust-repo

# [[file:../../notes/custom/README.org::cust-repo][cust-repo]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "CUST_S_REPO_HOST$CUST_S_REPO_PATH" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_REPO_HOST$CUST_S_REPO_PATH}{CUST_T_REPO_HOST$CUST_T_REPO_PATH}g"

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_REPO_PATH" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_REPO_PATH}{$CUST_T_REPO_PATH}g"
# cust-repo ends here




# #+NAME: cust-repo-post

# [[file:../../notes/custom/README.org::cust-repo-post][cust-repo-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_REPO_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-repo-post ends here

# Registry Address

# #+NAME: cust-regs-pre

# [[file:../../notes/custom/README.org::cust-regs-pre][cust-regs-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_REGS_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-regs-pre ends here



# #+NAME: cust-regs

# [[file:../../notes/custom/README.org::cust-regs][cust-regs]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "CUST_S_REGS_HOST$CUST_S_REGS_PATH}" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_REGS_HOST$CUST_S_REGS_PATH}{CUST_T_REGS_HOST$CUST_T_REGS_PATH}g"

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_REGS_PATH" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_REGS_PATH}{$CUST_T_REGS_PATH}g"
# cust-regs ends here




# #+NAME: cust-regs-post

# [[file:../../notes/custom/README.org::cust-regs-post][cust-regs-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_REGS_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-regs-post ends here

# Project Name

# #+NAME: cust-project-pre

# [[file:../../notes/custom/README.org::cust-project-pre][cust-project-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PROJECT_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-project-pre ends here



# #+NAME: cust-project

# [[file:../../notes/custom/README.org::cust-project][cust-project]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PROJECT_NAME" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_PROJECT_NAME}{$CUST_T_PROJECT_NAME}g"
# cust-project ends here




# #+NAME: cust-project-post

# [[file:../../notes/custom/README.org::cust-project-post][cust-project-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_PROJECT_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-project-post ends here

# Data Link

# #+NAME: cust-data-pre

# [[file:../../notes/custom/README.org::cust-data-pre][cust-data-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_DATA_LINK" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-data-pre ends here



# #+NAME: cust-data

# [[file:../../notes/custom/README.org::cust-data][cust-data]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_DATA_LINK" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_DATA_LINK}{$CUST_T_DATA_LINK}g"
# cust-data ends here




# #+NAME: cust-data-post

# [[file:../../notes/custom/README.org::cust-data-post][cust-data-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_PACKAGE_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-data-post ends here

# Project Description

# #+NAME: cust-pinfo-vers-pre

# [[file:../../notes/custom/README.org::cust-pinfo-vers-pre][cust-pinfo-vers-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
cat ./DESCRIPTION
# cust-pinfo-vers-pre ends here



# #+NAME: cust-pinfo

# [[file:../../notes/custom/README.org::cust-pinfo][cust-pinfo]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

perl -pi -e  "s/(given\s*=\\s*)\"\Q$CUST_S_INFO_AUTH_NAME\E\"/\1\"\Q$CUST_T_INFO_AUTH_NAME\E\"/" ./DESCRIPTION
perl -pi -e  "s/(family\s*=\\s*)\"\Q$CUST_S_INFO_AUTH_SURNAME\E\"/\1\"\Q$CUST_T_INFO_AUTH_SURNAME\E\"/" ./DESCRIPTION
perl -pi -e  "s/(email\s*+=\\s*)\"\Q$CUST_S_INFO_MAIL\E\"/\1\"\Q$CUST_T_INFO_MAIL\E\"/" ./DESCRIPTION
perl -pi -e  "s/(Title\s*:\\s*)\Q$CUST_S_INFO_TITLE\E/\1\Q$CUST_T_TITLE\E/" ./DESCRIPTION
perl -pi -e  "s/(Description\s*:\\s*)\Q$CUST_S_INFO_DESC\E/\1\Q$CUST_T_DESC\E/" ./DESCRIPTION
# cust-pinfo ends here



# #+NAME: cust-pinfo-post

# [[file:../../notes/custom/README.org::cust-pinfo-post][cust-pinfo-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
cat ./DESCRIPTION
# cust-pinfo-post ends here

# Image Description

# #+NAME: cust-binfo-pre

# [[file:../../notes/custom/README.org::cust-binfo-pre][cust-binfo-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
     grep -I -e 'org.opencontainers.image' -e 'it.unimib.datalab' {} \; | sort | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-binfo-pre ends here



# #+NAME: cust-binfo

# [[file:../../notes/custom/README.org::cust-binfo][cust-binfo]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(org.opencontainers.image.authors=\").*\"}{\1\Q${CUST_T_INFO_AUTHORS}\E\"}g" {} \;

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(org.opencontainers.image.description=\").*\"}{\1\Q${CUST_T_INFO_DESC}\E\"}g" {} \;

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(it.unimib.datalab.from=\").*\"}{\1\Q${CUST_T_INFO_FROM}\E\"}g" {} \;

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(it.unimib.datalab.owner=\").*\"}{\1\Q${CUST_T_INFO_OWNER}\E\"}g" {} \;

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(it.unimib.datalab.cdc=\").*\"}{\1\Q${CUST_T_INFO_CDC}\E\"}g" {} \;

find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
  perl -pi -e  "s{(it.unimib.datalab.tags=\").*\"}{\1\Q${CUST_T_INFO_TAGS}\E\"}g" {} \;
# cust-binfo ends here




# #+NAME: cust-binfo-post

# [[file:../../notes/custom/README.org::cust-binfo-post][cust-binfo-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find ./docker/r-images/dockerfiles -name '*.Dockerfile' -exec \
     grep -I -e 'org.opencontainers.image' -e 'it.unimib.datalab' {} \; | sort | \
    tr -s ' ' '_' | sed -e 's/:/\t/'
# cust-binfo-post ends here

# Confirm Customization

# #+NAME: cust-confirm-pre

# [[file:../../notes/custom/README.org::cust-confirm-pre][cust-confirm-pre]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort
# cust-confirm-pre ends here



# #+NAME: cust-confirm

# [[file:../../notes/custom/README.org::cust-confirm][cust-confirm]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

ls -l ./etc/custom/*.conf

T="$(date -Isec)"
mkdir -p ./etc/custom/done/$T

echo "=== reset renv dependecies, ..."
[ -f ./renv.lock ] && mv -v  ./renv.lock ./etc/custom/done/$T
echo "=== run renv::init() to re-initialize."

cp -pv   ./etc/custom/*.conf ./etc/custom/done/$T

find ./etc/custom | sort

cp -pv ./etc/custom/custom-target.conf ./etc/custom/custom-source.conf
perl -pi -e  "s/CUST_T_/CUST_S_/"      ./etc/custom/custom-source.conf

perl -pi -e  "s/CUST_X_CUSTOMIZED\s*=\s*0/CUST_X_CUSTOMIZED=1/" ./etc/custom/custom.conf

ls -l ./etc/custom/*.conf
# cust-confirm ends here




# #+NAME: cust-confirm-post

# [[file:../../notes/custom/README.org::cust-confirm-post][cust-confirm-post]]
[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort
# cust-confirm-post ends here

# Script Tail
# #+NAME: script-tail

# [[file:../../notes/custom/README.org::script-tail][script-tail]]
echo "<<< project customization, done."

echo '

 to check customized project, run:

 ./build.sh setup

 ./runtime.sh build all

 project developer s guide is available at:

    * https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r/-/blob/main/notes/usage/README.md

 '
 echo "see:  $LOGFILE "
 echo " "
# script-tail ends here
