#!/bin/sh

echo "$(date -Isec): $0 $@

do_make() {
   make -f $(dirname $0)/docker/r-images/Makefile $@
}


do_make runtime
