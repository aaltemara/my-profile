#!/bin/bash

code_bin_dir=$(dirname $0)

cd $code_bin_dir/../src

rsync -vr --exclude `basename $(dirname $0)` ./ ~/

echo "Done"

