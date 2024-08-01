#! /bin/bash

set -e

c0="\x1b[0;1;38;5;46m"
c1="\x1b[0;38;5;226m"
nc="\x1b[0m"

rm -rf Camera/Camera/imgs 2> /dev/null | true

# if has not files to be converted
files=$(fd '.*\.jpg$' Camera/Camera --size=+2m)
if [[ -z $files ]]; then
    exit 0;
fi

mkdir -p Camera/Camera/imgs

qtt=$(echo "$files" | wc -l)
cur=1
for f in $files; do
    name=$(basename $f)
    new_file=$(printf "Camera/Camera/imgs/${name}")
    size=$(du -h "$f" | cut -f1)
    size_noh=$(du "$f" | cut -f1)

    printf "📸  %03d / %03d >  from $c1[%5s]$nc: to " $cur $qtt $size

    cur=$(($cur + 1))
    magick "$f" -resize 40% "${new_file}"
    new_size=$(du -h "${new_file}" | cut -f1)
    new_size_noh=$(du "${new_file}" | cut -f1)
    percent=$(echo "scale=2; $new_size_noh / $size_noh" | bc -l)
    printf "$c0[%5s] ${percent#*.}%%$nc, %s\n" $new_size $name
done

if [[ -d Camera/Camera/imgs ]]; then
    printf "\n Replace originals❓ [N/y] "
    read replace
    replace=$(echo "$replace" | tr '[:upper:]' '[:lower:]')
    if [[ -z $replace || $replace == "n" ]]; then
        echo " 👋 bye, the converted images are in [Camera/Camera/imgs/], check out.";
        exit 0;
    fi

    mv Camera/Camera/imgs/* Camera/Camera/
    rm -rf Camera/Camera/imgs
fi
