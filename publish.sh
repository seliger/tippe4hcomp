#!/usr/bin/env bash

HUGO_ENV="production"

hugo
aws s3 sync public/ s3://tippe4hcomp.org/
aws cloudfront create-invalidation --distribution-id EZY0MMS5J7SWB --paths "/*"

