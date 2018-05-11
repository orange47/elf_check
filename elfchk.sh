#!/bin/bash

echo "usage: elfchk.sh elfs.db  inputdir/ "

if [[ $# -eq 0 ]] ; then
    echo 'no args'
    exit 0
fi

dbfile="$1"
elfdir="$2"

IFS=$'\n'


  for f in $(find "$elfdir" -type f)
  do
   if file -b -e apptype -e ascii -e encoding -e tokens -e cdf -e compress -e elf -e tar -e text "$f" | grep -i -q ^elf 
   then
    fname=`basename "$f"`
    flen=`stat -c %s "$f"`
    flenhex=`echo "obase=16; $flen" |bc`  #hex
    sha=`rhash -p %B{sha3-512} "$f"`
    shack="$sha/$flenhex/$fname"
    if ! grep -Fx -q "$shack" "$dbfile" #proveriti x
    then
     echo "ERR:$shack"
#     else
#      echo "OK:$shack"
    fi
   fi
  done
 

 echo "DONE"
exit 0



# real    61m14.593s bez -e


#  -e apptype -e ascii -e encoding -e tokens -e cdf -e compress -e elf -e soft -e tar -e text    
