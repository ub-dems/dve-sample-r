##
# @see: https://binx.io/blog/2017/10/07/makefile-for-docker-images/
#

#REGISTRY_HOST=docker.io
#USERNAME=$(USER)

#mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
#mkfile_dir := $(dir $(mkfile_path))

#REGISTRY_HOST=https://svsi680reg.azurecr.io
# REGISTRY_HOST=
# USERNAME := $(mkfile_dir)


all: build push
clean: showver


help:
	@echo ""	
	@echo "   usage: make 'target'    " 
	@echo "   where  'target' in    "
	@echo ""	
	@echo "    - pre-build     "
	@echo "    - docker-build    " 
	@echo "    - post-build    "
	@echo "    - build    "
	@echo "    - release    " 
	@echo "    - patch-release    "
	@echo "    - minor-release    "
	@echo "    - major-release    "
	@echo "    - tag    " \
	@echo "    - check-status    "
	@echo "    - check-release    "
	@echo "    - showver    "
	@echo "    - push    "
	@echo "    - pre-push    "
	@echo "    - do-push    "
	@echo "    - post-push   "
	@echo ""	
	@echo "   see also:    "
	@echo "   		https://binx.io/blog/2017/10/07/makefile-for-docker-images    " 
	@echo ""	


include ../make/Makefile

