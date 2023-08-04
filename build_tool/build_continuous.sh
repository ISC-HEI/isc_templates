#!/bin/bash
# FIXME : a change in NNN-ABCD/figs/ does not rebuild the pdf...
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! [ -x "$(command -v inotifywait)" ]; then
  >&2 echo "error: inotifywait not found"
  >&2 echo "on ubuntu this can be fixed using : sudo apt install inotify-tools"
  exit 1
fi

pushd "$SCRIPT_DIR" || exit
inotifywait -e close_write,moved_to,create -m -q -r ".." |
while read -r directory _ filename; do
  echo "directory=$directory"
  if [[ $directory =~ \.\.\/[[:digit:]]{3}.* ]]; then
      if ! [[ $filename =~ .*\.pdf ]]; then
          "$SCRIPT_DIR/build_pandoc.sh" -n "$directory"
      fi
  fi
done
