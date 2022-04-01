#!/bin/sh

echo "$(date -Isec): $0 $@
exec Rscript exec/worker.R $@

