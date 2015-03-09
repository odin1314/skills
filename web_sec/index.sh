#!/bin/bash

for dir in $(find ./ -type d|grep "source/.*")
do
    #echo $dir
    touch $dir/index.rst
done

