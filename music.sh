
#!/bin/bash
# create a random playlist with music and play it
# htor bash god

set -e

target_directory=C:/Users/na/Music

num_tracks=60
playlist=$(mktemp)
mv $playlist $playlist.m3u
playlist=$playlist.m3u

case $# in
    0)
        if [[ ! -d $target_directory ]]
        then
            echo "default directory $target_directory not mounted, doing nothing"
            exit 1
        fi ;;
    1)
        target_directory=$1 ;;
    2)
        target_directory=$1
        num_tracks=$2 ;;
    *)
        echo "usage: randmusic <directory> <num-tracks>"
        exit 1 ;;
esac

echo "#EXTM3U" > $playlist
find $target_directory -maxdepth 3 -type f \
    -iregex '.*/[^.]+\.\(flac\|mp3\|ogg\|wav\|aiff?\)$' | \
    shuf -n $num_tracks | \
    while read file
    do
        echo "#EXTINF:0,$(basename "$file")" >> $playlist
        echo "$file" >> $playlist
    done
foobar2000 $playlist

