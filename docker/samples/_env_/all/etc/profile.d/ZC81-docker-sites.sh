##
# docker env: wp-sites
#

case "$(hostname)" in
    pw-bs110-v01) export DK_URL='pw-bs110-lab1696242171000.westeurope.cloudapp.azure.com';;
    es-ux610-v11) export DK_URL='es-ux610-lab2015858905000.westeurope.cloudapp.azure.com';;
    *) echo "### unknown ...";;
esac
case "$(hostname)" in
    pw-bs110-v01) export DK_PUB='1';;
    es-ux610-v11) export DK_PUB='0';;
    *) echo "### unknown ...";;
esac
# DK_ENV_FILE="${${DK_ENV:-dev}/dev/override}"
[ -z "$DK_ENV" ] && export DK_ENV='dev'
case "${DK_ENV}" in
	dev) export DK_ENV_FILE='override';;
	*)   export DK_ENV_FILE="$DK_ENV";;
esac	
export DK_ENV_FILE
export DK_COMPOSE_FILE="docker-compose.yml:docker-compose.$DK_ENV_FILE.yml"
export DK_STACK_FILE="--compose-file docker-compose.yml -c docker-compose.$DK_ENV_FILE.yml"
export COMPOSE_FILE="$DK_COMPOSE_FILE"


