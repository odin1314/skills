#!/bin/bash

for dir in $(find ./ -type d|grep "Linux*")
do
    touch $dir/index.rst
done

