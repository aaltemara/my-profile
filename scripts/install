#!/bin/bash

code_bin_dir=$(dirname $0)

cd $code_bin_dir/../src

echo rsync -vr --exclude `basename $(dirname $0)` ./ ~/
rsync -vr --exclude `basename $(dirname $0)` ./ ~/

echo "Done"

