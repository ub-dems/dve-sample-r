#!/bin/bash
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

whoami

hostnamectl | \
    perl -p -e 's/([^ :])\s+(\S)/\1_\2/g' | sed -e 's/:/\t/'

ip -br -4 a | grep -v lo

pwd

git remote -v

git -c color.ui=false status | \
    sed -e 's/^/> /'

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

[ -f ./etc/custom/custom-source.conf ] || sed 's/^ *//' >> ./etc/custom/custom-source.conf <<-EOF
# project source consts
CUST_S_PROJECT_NAME='dve-sample-r'
CUST_S_PACKAGE_NAME='dvesimpler'
CUST_S_REPO_PATH='ub-dems-public/ds-labs'
CUST_S_REPO_HOST='https://gitlab.com/'
EOF

[ -f ./etc/custom/custom-target.conf ] || sed 's/^ *//' >> ./etc/custom/custom-target.conf <<-EOF
# project target consts
CUST_T_PROJECT_NAME='us-proto-r'
CUST_T_PACKAGE_NAME='USprotoR'
CUST_T_REPO_PATH='ub-dems/cs-labs/user-dsuser'
CUST_T_REPO_HOST='https://gitlab.com/'
EOF

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort

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

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find . -name "$CUST_S_PACKAGE_NAME*" -o -name "$CUST_S_PROJECT_NAME*"

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

mv -v ./${CUST_S_PACKAGE_NAME}.Rproj ./${CUST_T_PACKAGE_NAME}.Rproj
mv -v ./man/${CUST_S_PACKAGE_NAME}-package.Rd ./man/${CUST_T_PACKAGE_NAME}-package.Rd
mv -v ./R/${CUST_S_PACKAGE_NAME}.r ./R/${CUST_T_PACKAGE_NAME}.r

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
find . -name "$CUST_T_PACKAGE_NAME*" -o -name "$CUST_T_PROJECT_NAME*"

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PACKAGE_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PACKAGE_NAME" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_PACKAGE_NAME}{$CUST_T_PACKAGE_NAME}g"

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_PACKAGE_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_REPO_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

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

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_REPO_PATH" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PROJECT_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

grep -l -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_S_PROJECT_NAME" | \
  xargs -t -l1 perl -pi -e  "s{$CUST_S_PROJECT_NAME}{$CUST_T_PROJECT_NAME}g"

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
grep -r \
     --exclude-dir=.git --exclude-dir=custom --exclude-dir=notes --exclude-dir=logs \
     -I -e "$CUST_T_PROJECT_NAME" | \
    tr -s ' ' '_' | sed -e 's/:/\t/'

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
[ "${CUST_X_CUSTOMIZED}" = '0' ] || exit 1

ls -l ./etc/custom/*.conf

T="$(date -Isec)"
mkdir -p ./etc/custom/done/$T
cp -pv   ./etc/custom/*.conf ./etc/custom/done/$T

find ./etc/custom | sort

cp -pv ./etc/custom/custom-target.conf ./etc/custom/custom-source.conf

perl -pi -e  "s/CUST_X_CUSTOMIZED\s*=\s*0/CUST_X_CUSTOMIZED=1/" ./etc/custom/custom.conf

ls -l ./etc/custom/*.conf

[ -f ./etc/custom/custom.conf ] && . ./etc/custom/custom.conf
env | grep ^CUST_ | tr '=' '\t' | sort

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
