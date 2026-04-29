#!/bin/bash
set -euo pipefail

URL="$1"

if [[ -z "${URL:-}" ]]; then
  echo "Usage: $0 <youtube_url>"
  exit 1
fi

#YTDLP="/home/fahim/.local/bin/yt-dlp"
YTDLP="yt-dlp"
ARCHIVE="archive.txt"

COMMON_OPTS=(
  --write-thumbnail
  --write-info-json
  --write-description
  --write-subs
  --sub-lang "en.*"
  --download-archive "$ARCHIVE"
  --remote-components ejs:github
)

CHANNEL_OUT="media/youtube/channels/%(channel)s/%(upload_date)s - %(title)s [%(id)s]/%(upload_date)s - %(title)s [%(id)s].%(ext)s"

LIKED_OUT="media/youtube/liked/%(channel)s - %(upload_date)s %(title)s [%(id)s]/%(upload_date)s  %(title)s [%(id)s].%(ext)s"

echo "▶ Processing: $URL"

# crude but reliable enough for yt URLs
if [[ "$URL" =~ watch\?v= ]]; then
  echo "▶ Detected single video"
  "$YTDLP" "${COMMON_OPTS[@]}" -o "$LIKED_OUT" "$URL"

else
  echo "▶ Detected playlist or channel"
  "$YTDLP" "${COMMON_OPTS[@]}" -o "$CHANNEL_OUT" "$URL"
fi
