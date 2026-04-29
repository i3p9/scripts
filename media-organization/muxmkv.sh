#!/bin/bash

t=$(which mkvmerge)
if [ -z "$t" ]; then
    echo "mkvtoolnix/mkvmerge not found, install using brew install mkvtoolnix"
    exit 1
fi

find . -maxdepth 1 -type f -name "*.mkv" -print0 | while IFS= read -r -d '' file; do
    base="${file%.mkv}"  # Remove .mkv extension safely
    mkvmerge -o "remux-${base##*/}.mkv" "$file" --forced-track "0:yes" --default-track "0:yes" --track-name "0:English" --language "0:eng" "${base##*/}.srt"
done
