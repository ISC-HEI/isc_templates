#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_CMD="./build_pandoc.sh -n"

if parallel --version &> /dev/null; then
  echo "Building all PDF files in parallel..."
  USE_PARALLEL=1
else
  >&2 echo "WARNING: gnu parallel not found"
  echo "Building all PDF files..."
  USE_PARALLEL=0
fi

pushd "$SCRIPT_DIR" || exit 1
dirs=(../???-*)

if [[ USE_PARALLEL -eq 1 ]]; then
  parallel --progress --bar --eta "$BUILD_CMD" ::: "${dirs[@]}"
else
  for d in "${dirs[@]}"
  do
    $BUILD_CMD "$d"
  done
fi

popd || exit 1
