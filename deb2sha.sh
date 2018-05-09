#!/bin/bash
#elf -> sha
#sudo mount -t tmpfs -o size=3g,gid=1000,uid=1000,noatime tmpfs /mnt/ramdisk/

echo "usage: deb2sha.sh inputdir/ outputdir/"

if [[ $# -eq 0 ]] ; then
    echo 'no args'
    exit 0
fi

tempdir='/mnt/ramdisk/1'
aptdir="$1"
date=`date +%Y-%m-%d`
output="$2$date"
mkdir "$output"

IFS=$'\n'


function sumit {
 workdir="$1"
 outputfile="$output/$2.sha3"

 for fdeb in $(find $workdir -mmin -300 -name '*.deb' -type f)
 do
  fakeroot dpkg -x "$fdeb" "$tempdir"

  for f in $(find "$tempdir" -name '*' -type f)
  do
   if file "$f" | grep -q ": ELF " 
   then
    fname=`basename "$f"`
    flen=`stat -c %s "$f"`
    sha=`rhash --sha3-512 "$f" | head -c 128`
    echo "$sha,$flen,$fname" >> "$output/$outputfile"
   fi
  done
 
  rm -rf "$tempdir"
 
 done

}  






for x in {{0..9},{a..z},lib{0..9},lib{a..z}}
do
      echo "$x"
    for d in $(find "$aptdir" -regextype egrep  -regex ".*\/(contrib|main|non-free)\/$x\/.*"  -type d)
    do
     sumit "$d" "$x"
    done
    
done

cat $output/*.sha3 | sort -u >$output/dbfile_$date.dat
