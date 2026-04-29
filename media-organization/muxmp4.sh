#!/bin/bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: muxmp4.sh subtitle.srt input.mp4 [output.mp4] [language]

Adds an SRT subtitle track to an MP4 using MP4Box.

Examples:
  muxmp4.sh "Once.2007.1080p.BluRay.x265-RARBG.srt" \
    "Once.2007.1080p.BluRay.x265-RARBG.mp4" \
    "Once_2007.mp4"

  muxmp4.sh intern.srt intern.mp4 "The.Intern.2015.1080p.BluRay.x265-RARBG.mp4"
EOF
}

default_output_name() {
    local input_file="$1"

    case "$input_file" in
        *.mp4) printf '%s\n' "${input_file%.mp4}.subbed.mp4" ;;
        *) printf '%s\n' "${input_file}.subbed.mp4" ;;
    esac
}

if [ $# -lt 2 ] || [ $# -gt 4 ]; then
    usage
    exit 1
fi

mp4box_bin=$(command -v MP4Box || command -v mp4box || true)
if [ -z "$mp4box_bin" ]; then
    echo "MP4Box not found, install GPAC using brew install gpac"
    exit 1
fi

subtitle_file=$1
input_file=$2
output_file=${3:-$(default_output_name "$input_file")}
language=${4:-eng}

if [ ! -f "$subtitle_file" ]; then
    echo "Subtitle file not found: $subtitle_file"
    exit 1
fi

if [ ! -f "$input_file" ]; then
    echo "Input MP4 not found: $input_file"
    exit 1
fi

if [ "$output_file" = "$input_file" ]; then
    echo "Output file must be different from the input file"
    exit 1
fi

"$mp4box_bin" -add "${subtitle_file}:hdlr=sbtl:lang=${language}" "$input_file" -out "$output_file"
echo "Created: $output_file"
