#!/bin/bash

# for channels.txt
#yt-dlp --cookies-from-browser firefox --write-thumbnail --write-info-json --write-description \
#--write-sub --sub-lang en --download-archive archive.txt \
#-o "downloads/%(channel)s/%(upload_date)s - %(title)s [%(id)s]/%(upload_date)s - %(title)s [%(id)s].%(ext)s" \
#--batch-file channels.txt

#for downloading channels in 1080p
yt-dlp --cookies-from-browser firefox --write-thumbnail --write-info-json --write-description \
--write-subs --sub-lang "en.*" --download-archive archive.txt --format "bv[height<=1080]+ba/b[height<=1080]" \
-o "downloads/%(channel)s/%(upload_date)s - %(title)s [%(id)s]/%(upload_date)s - %(title)s [%(id)s].%(ext)s" \
--batch-file channels_1080p.txt

#for downloading channels in 720p
yt-dlp --cookies-from-browser firefox --write-thumbnail --write-info-json --write-description \
--write-subs --sub-lang "en.*" --download-archive archive.txt --format "bv[height<=720]+ba/b[height<=720]" \
-o "downloads/%(channel)s/%(upload_date)s - %(title)s [%(id)s]/%(upload_date)s - %(title)s [%(id)s].%(ext)s" \
--batch-file channels_720p.txt

#for liked videos playlist
yt-dlp --cookies-from-browser firefox --write-thumbnail --write-info-json --write-description \
--write-subs --sub-lang "en.*" --download-archive archive.txt \
-o "downloads/Liked/%(channel)s - %(upload_date)s %(title)s [%(id)s]/%(upload_date)s  %(title)s [%(id)s].%(ext)s" \
'https://www.youtube.com/playlist?list=LL'