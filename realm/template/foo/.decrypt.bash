#!/usr/bin/env bash
set -euo pipefail

for e in $(find . -name "enc.$1.values.yaml"); do
  echo "sops -d $e > $(echo $e | sed 's/enc\.'"$1"'\.//')"
  sops -d $e > $(echo $e | sed 's/enc\.'"$1"'\.//')
done