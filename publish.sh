#!/usr/bin/env bash

HUGO_ENV="production"

hugo
hugo deploy --invalidateCDN --maxDeletes -1