#!/usr/bin/env bash

hugo -e production
hugo deploy --invalidateCDN --maxDeletes -1
