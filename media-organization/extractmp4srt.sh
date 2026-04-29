#!/bin/bash

set -euo pipefail
marker=""

usage() {
    cat <<'EOF'
Usage: extractmp4srt.sh track_id input.mp4 [output.srt]

Extracts an embedded subtitle track from an MP4 using MP4Box.

Examples:
  extractmp4srt.sh 3 filename.mp4
  extractmp4srt.sh 3 filename.mp4 extracted.srt
EOF
}

append_unique() {
    local candidate="$1"
    local existing

    for existing in "${new_files[@]}"; do
        if [ "$existing" = "$candidate" ]; then
            return
        fi
    done

    new_files+=("$candidate")
}

collect_new_srt_files() {
    local dir="$1"
    local file

    while IFS= read -r file; do
        [ -n "$file" ] || continue
        append_unique "$file"
    done < <(find "$dir" -maxdepth 1 -type f -name "*.srt" -newer "$marker" -print 2>/dev/null)
}

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    usage
    exit 1
fi

mp4box_bin=$(command -v MP4Box || command -v mp4box || true)
if [ -z "$mp4box_bin" ]; then
    echo "MP4Box not found, install GPAC using brew install gpac"
    exit 1
fi

track_id=$1
input_file=$2
output_file=${3:-}

if ! [[ "$track_id" =~ ^[0-9]+$ ]]; then
    echo "Track ID must be numeric"
    exit 1
fi

if [ ! -f "$input_file" ]; then
    echo "Input MP4 not found: $input_file"
    exit 1
fi

input_dir=$(cd "$(dirname "$input_file")" && pwd)
current_dir=$PWD
marker=$(mktemp)
new_files=()
trap 'rm -f "$marker"' EXIT

"$mp4box_bin" -srt "$track_id" "$input_file"

collect_new_srt_files "$current_dir"
if [ "$input_dir" != "$current_dir" ]; then
    collect_new_srt_files "$input_dir"
fi

if [ -n "$output_file" ]; then
    if [ "${#new_files[@]}" -ne 1 ]; then
        echo "Subtitle extracted, but the output file could not be identified for renaming."
        if [ "${#new_files[@]}" -gt 0 ]; then
            printf 'Detected subtitle files:\n'
            printf '%s\n' "${new_files[@]}"
        fi
        exit 1
    fi

    mv -f "${new_files[0]}" "$output_file"
    echo "Created: $output_file"
    exit 0
fi

if [ "${#new_files[@]}" -eq 1 ]; then
    echo "Created: ${new_files[0]}"
elif [ "${#new_files[@]}" -gt 1 ]; then
    printf 'Created subtitle files:\n'
    printf '%s\n' "${new_files[@]}"
else
    echo "Subtitle extracted. MP4Box handled the output name."
fi
