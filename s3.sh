#!/bin/bash
for file in ./test.folder/*; do
 aws s3 cp $file s3://milanco-bucket
done
