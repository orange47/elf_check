#!/bin/bash
#elf -> sha
#sudo mount -t tmpfs -o size=5g,gid=1000,uid=1000,noatime tmpfs /mnt/ramdisk/

echo "usage: deb2sha.sh inputdir/ outputdir/"

if [[ $# -eq 0 ]] ; then
    echo 'no args'
    exit 0
fi

tempdir='/mnt/ramdisk/1'
aptdir="$1"
date=`date +%Y-%m-%d`
outbase="$2"
output="$2$date"
mkdir "$output"

IFS=$'\n'


function sumit {
 workdir="$1"
 outputfile="$output/$2.sha3"

 for fdeb in $(find $workdir -name '*.deb' -type f)
 do
  fakeroot dpkg -x "$fdeb" "$tempdir"

  for f in $(find "$tempdir" -name '*' -type f)
  do
   if file -b -e apptype -e ascii -e encoding -e tokens -e cdf -e compress -e elf -e tar -e text  "$f" | grep -i -q ^elf 
   then
    fname=`basename "$f"`
    flen=`stat -c %s "$f"` #decimal
    flenhex=`echo "obase=16; $flen" |bc`  #hex
    sha=`rhash  -p %B{sha3-512} "$f"` #base64
    echo "$sha/$flenhex/$fname" >> "$outputfile"
   fi
  done
 
  rm -rf "$tempdir"
 
 done

}  






for x in {{0..9},{a..z},lib{0..9},lib{a..z}}
# for x in {0..1}
do
      echo "$x"
    for d in $(find "$aptdir" -regextype egrep  -regex ".*\/(contrib|main|non-free)\/$x\/.*"  -type d)
    do
     sumit "$d" "$x"
    done
    
done

find $outbase/ -name "*.sha3" -type f  -exec cat {} \;  | sort -u >elfs.db 
