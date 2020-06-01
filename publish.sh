#!/usr/bin/env bash

HUGO_ENV="production"

hugo --gc --minify
hugo deploy --invalidateCDN --maxDeletes -1
