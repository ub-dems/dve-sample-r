#!/bin/sh
#
# Copy of https://gist.githubusercontent.com/arichika/b1a1413b554734ae964f/raw/e657ad2dc4ddab60750d26e87add61f9b988d887/ConvertLetsPemToPfx.sh
#
: ${CERT_EXP_DIR:='.'}
pemsdir="${CERT_EXP_DIR}/etc/letsencrypt/archive"      # default search PEMs
pfxspath="${CERT_EXP_DIR}/share/letsencrypt/archive"   # dest of the PFXs
passfile="${CERT_EXP_DIR}/share/letsencrypt/pass.txt"  # password to be applied to the PFX file

for cnvifull in `find -L "${pemsdir}" -name 'cert*.pem' -o -name '*chain*.pem'`
do

  cnvifile=${cnvifull##*/}
  cnvinum=`echo ${cnvifile%.*} | sed -e "s#[cert|chain|fullchain]##g"`
  cnvipkey="${cnvifull%/*}/privkey${cnvinum}.pem"

  cnvopem=`echo ${cnvifull} | sed -e "s#${pemsdir}#${pfxspath}#g"`
  cnvofull="${cnvopem%.*}.pfx"

  echo "- :-) ->"
  echo "-in    ${cnvifull}"
  echo "-inkey ${cnvipkey}"
  echo "-out   ${cnvofull}"


  mkdir -p ${cnvofull%/*}

  openssl pkcs12 \
    -export \
    -in ${cnvifull} \
    -inkey ${cnvipkey} \
    -out ${cnvofull} \
    -passout file:${passfile}

done
